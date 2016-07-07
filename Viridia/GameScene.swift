//
//	GROVEKEEPER
//
//  GameScene.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/17/16.
//  Copyright (c) 2016 Dilan Jenkins. All rights reserved.
//
//==========
//	TODO
//==========
//	(BUG)Newly spawned rocks that are moving upwards change down to 1 life when hit by bomb box
//	(!!!)change spawn rates of boxes with difficulty level
//	(!!!)pause button that lets player pause the game when in LevelScene
//		TEST THAT LOSE/WIN still works correctly
//	should have a tutorial system
//		(?)link to it on the menu?
//		might be better in stages, i.e stage for:
//			fire plants, tap to shoot flame
//			sand spiders, tap to kill
//			boxes, drag to move left and right
//			different box types and what they do
//	remove right most ground from generation of plants/rocks/firePlants
//	timed mode that wins after certain amount of time
//		just add a victoryCondition class and add totalTimeElapsed counter to update function in GameScene
//		would probably need to show a timer(count up or down) somewhere in the scene
//	Need some kind of score system
//		(DONE)Score calculation
//		(DONE)score should be shown alongside message,tap to continue..
//		add grass,shroomy ground to score similar to plants
//		score should never be negative, i.e lost plants/sandy ground do not count against score(they just don't add to the score)
//	animate spider dying from being tapped
//		make the spider shrink and change sprite/roll to just dead spider
//	Animate sand spider being created,i.e have it come out of ground like rock
//		would not animate/move left or right until reached ground level
//	Screen that shows options for the game, difficulty level and win condition( time versus total)
//
//	Sound Effects
//		(NEED SOUND)sound effect for fire plant firing when tapped
//		(?)sound effect for spider eating a plant down by one life
//			just use plant die sound effect?
//
//	-------------
//	FUTURE
//	============
//	(SCRAP)More accurate portrayal of boxes so that what is inside them has an icon of it
//	(SCRAP)Animate spider eating a plant
//	(NEED SPRITE)particle effect for when box hits ground, sand spilling out/spores
//	(NEED SPRITE)fire explosion animation for when fireball hits a box
//	(EDIT SPRITE)rock being built up animation for when rock gets hit by rock box
//	(NEED SPRITE)particle effect for when rocks get hit by bombBox
//	(NEED SPRITE)particle effect for when BombBox hits sand, creating spider
//	(EDIT SPRITE)snail shells that spawn like rocks
//		when bomb box hits snail shell, snail gets out and wreaks havoc on plants nearby similar to sand monster
//		would need to recolor snail from pink?
//
//	maybe allow player to adjust how many boxes generated/how much time to survive in Setup Game Settings Scene
//	Need to save best score for difficulty into file
//	lose level animation, rocks all get destroyed and turns into desolate sandy wasteland
//		maybe have a tumbleweed blow across the screen
//	time attack mode that starts off easy and gets harder as you go along, see how long you can survive
//	maybe have a 2 second pause between music on the list played(use a timer)
//	(?)don't add buttons to view for credits/menu until the transition is done
//	(?)RockBox should kill any plants it touches ground of and replace them with Rocks
//		(EDIT SPRITE)or have it fossilize the plant, making it stony and any bombbox that hits it explodes like a rock, killing plant
//			spiders would also be unable to eat it,kills spider as soon as it tries
//	(?)heal box should also plant a plant(only one) when it hits empty ground
//		(?)heal box should turn regular plants into fireplants(only one) when hits grassy ground
//		Maybe have another box that does these two things similar to rockbox
//	(?)should cacti only be on sand?
//		i.e have shrooms turn into cacti?
//	(?)step counter for generators should be based off seconds * framesPerSecond for readability
//	(?)collisions should be based on non-transparent parts of the sprite
//		probably not possible, would require complete rewrite of collision engine
//		see GameObj init code for more info
//	(?)spider-predation plant, the plant eats the spiders when they get close
//	(?)Might have all boxes(except rockBox) damage rock on impact instead of just BombBox
//==========
//

import SpriteKit
import AVFoundation

class GameScene: SKScene
{
	//list of game objects currently in the scene
	var gameObjects = [GameObj]()
	
	//the last time that the frames were drawn, i.e update method was called
	var lastTime : CFTimeInterval = 0
	
	//the last value for the FPS in update
	private(set) var lastFPS : Int = 0
	
	//the object currently touched by the player
	var objectTouched : GameObj!
	
	//a list of generator objects that are stepped over when update is called
	var generatorList = [ObjGenerator]()
	
	//whether the update function is paused or not
	var pauseUpdate = false
	
	//whether the current game level is won/lost or is still being played
	var doneScreen = false
	
	//a list of objects that are queued to be added to the gameObjects array
	var objCreateQueue = [GameObj]()
	
	var myController : GameViewController!
	
	//a list of object class names, and how many instances of said class have been created
	var objectsCreated = [ String : Int ]()
	
	//a list of object class names, and how many instances of said class have been destroyed
	var objectsDestroyed = [ String : Int ]()
	
	/*
	override func didMoveToView(view: SKView)
	{
		/* Setup your scene here */
		/*
		let myLabel = SKLabelNode(fontNamed:"Chalkduster")
		myLabel.text = "Hello, World!"
		myLabel.fontSize = 45
		myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
		self.addChild(myLabel)
		*/
		
		/*
		createBackground()
		setupGenerators()
		createLayer( false , atLayer: 1 )
		createLayer( true , atLayer: 2 )
		generateScenery()
		shouldCheckLose = true
		*/
	}
	*/
	
	/* Called before each frame is rendered */
	override func update(currentTime: CFTimeInterval)
	{
		//get the difference in time from last time
		let deltaTime = currentTime - lastTime
		let currentFPS = Int( floor( 1 / deltaTime ) )
		lastTime = currentTime
	
		if ( pauseUpdate )
		{
			return
		}
		
		generateObjects( currentFPS )
		checkCollide()
		var newList = [GameObj]()
		for obj in gameObjects
		{
			if ( obj.isDead )
			{
				removeGameObject( obj )
				continue
			}
			
			obj.updateEvent( self, currentFPS: currentFPS )
			obj.move( currentFPS )
			
			if ( !obj.checkPositionToBoundaries( frame.width , yEnd: frame.height ) )
			{
				obj.outsideRoomEvent( frame.height, roomWidth: frame.width )
				if ( obj.isDead )
				{
					removeGameObject( obj )
					continue
				}
			}
			
			newList.append( obj )
		}

		gameObjects.removeAll()
		gameObjects = newList
		
		for obj in objCreateQueue
		{
			addGameObject( obj )
			objCreateQueue.removeFirst()
		}

		lastFPS = currentFPS
		lastTime = currentTime
	}
	
	func isObjOutsideRoom( obj : GameObj ) -> Bool
	{
		return !( obj.checkPositionToBoundaries( frame.width, yEnd: frame.height ) )
	}
	
	/* Called when a touch begins */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
        /*
        for touch in touches
		{
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
		*/
		
		//create a box at the position that the user touched
		for touch in touches
		{
			let location = touch.locationInNode(self)
			for obj in gameObjects
			{
				if obj.sprite.frame.contains( location )
				{
					obj.touchEvent( location )
					objectTouched = obj
				}
			}
		}
    }
	
	/* called when a touch moves */
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		for touch in touches
		{
			if ( objectTouched == nil )
			{
				break
			}
			
			if ( objectTouched.isDead )
			{
				objectTouched = nil
				break
			}
			
			let location = touch.locationInNode(self)
			objectTouched.dragEvent( location )
		}
	}
	
	/* Called when a touch ends, i.e user lifts finger */
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		for touch in touches
		{
			if ( objectTouched == nil )
			{
				break
			}
			
			if ( objectTouched.isDead )
			{
				objectTouched = nil
				break
			}
			
			let location = touch.locationInNode(self)
			objectTouched.stopDragEvent( location )
			objectTouched = nil
		}
	}
	
	//checks for collisions in all objects and calls collideEvent for objects that collide with one another
	func checkCollide()
	{
		var outerIndex = -1
		for obj in gameObjects
		{
			outerIndex += 1
			if ( obj.isDead )
			{
				continue
			}
		
			var collideGroup = [(Int,Int) ]()
			var innerIndex = -1
			for other in gameObjects
			{
				innerIndex = innerIndex + 1
				if innerIndex == outerIndex
				{
					continue
				}
				
				if ( obj.doesCollide( other ) )
				{
					if ( !pairIsInArray( collideGroup, indexOne: outerIndex, indexTwo: innerIndex ) )
					{
						collideGroup.append( (outerIndex, innerIndex) )
					}
				}
			}
			
			for collide in collideGroup
			{
				let obj = gameObjects[ collide.0 ]
				let other = gameObjects[ collide.1 ]
				obj.withID( collide.0 ).collideEvent( other )
				other.withID( collide.1 ).collideEvent( obj )
			}
		}
	}
	
	
	func pauseAndShowMessage( message : String, subMessage : String = "" ) -> [SKLabelNode]
	{
		var toReturn = [SKLabelNode]()
		if ( pauseUpdate )
		{
			return toReturn
		}
		
		pauseUpdate = true
		var myLabel = addMakeLabel( message, xPos : CGRectGetMidX(self.frame), yPos : CGRectGetMidY(self.frame), fontSize: 45 )
		toReturn.append( myLabel )
		if ( subMessage != "" )
		{
			myLabel = addMakeLabel( subMessage, xPos : CGRectGetMidX(self.frame), yPos : CGRectGetMidY(self.frame) - myLabel.fontSize, fontSize: 30 )
			toReturn.append( myLabel )
		}
		myLabel = addMakeLabel( "Tap to Continue", xPos : CGRectGetMidX(self.frame), yPos : myLabel.position.y - myLabel.fontSize, fontSize: 30 )
		toReturn.append( myLabel )
		
		return toReturn
	}
	
	func addMakeLabel( message : String, xPos : CGFloat, yPos : CGFloat, fontSize : CGFloat ) -> SKLabelNode
	{
		let myFont = "Thonburi"//"Verdana"//"Thonburi"
		let otherLabel = SKLabelNode(fontNamed: myFont )
		otherLabel.text = message
		otherLabel.fontSize = fontSize
		otherLabel.position = CGPoint(x: xPos , y: yPos )
		otherLabel.zPosition = 100
		otherLabel.fontColor = UIColor.blackColor()
		self.addChild(otherLabel)
		return otherLabel
	}
	
	func playSoundEffect( fileName : String )
	{
		if ( myController != nil && myController.isMuted )
		{
			return
		}
		runAction(SKAction.playSoundFileNamed( fileName , waitForCompletion: false))
	}
	
	//steps through every generator object and increments counter for said object
	//then calls generate method on sais object if it is readyToGenerate
	//adds the resulting object to the list of objects
	func generateObjects( currentFPS: Int )
	{
		for gen in generatorList
		{
			gen.incrementSteps()
			if ( gen.readyToGenerate )
			{
				let obj = gen.generate()
				if ( obj != nil )
				{
					addGameObject( obj! )
				}
			}
		}

	}
	
	//removes the game object from the list of game objects and from the scene
	final func removeGameObject( obj : GameObj )
	{
		let objClass = obj.className()
		if ( objectsDestroyed[ objClass ] != nil )
		{
			objectsDestroyed[  objClass ]! += 1
		}
		else
		{
			objectsDestroyed[ objClass ] = 1
		}
		
		obj.deleteEvent( self )
		self.removeChildrenInArray( [ obj.sprite ])
	}
	
	//adds the object and its sprite to the game view data, returns obj for chaining
	final func addGameObject( obj : GameObj ) -> GameObj
	{
		let objClass = obj.className()
		if ( objectsCreated[ objClass ] != nil )
		{
			objectsCreated[  objClass ]! += 1
		}
		else
		{
			objectsCreated[ objClass ] = 1
		}
		
		self.gameObjects.append( obj.createEvent( self ) )
		self.addChild( obj.sprite )
		return obj
	}
	
	//adds the object to the queue for creation
	func queueGameObject( obj : GameObj ) -> GameObj
	{
		self.objCreateQueue.append( obj )
		return obj
	}
	
	//creates a layer of sprites across the bottom of the screen
	func createLayer( isTop: Bool, atLayer: Int ) -> CGFloat
	{
		let objForSize = GroundObj( isTop: isTop , xStart: 0, yStart: 0 )
		let totalSprites = Int( ceil( self.frame.width / objForSize.sprite.frame.width ) ) + 1
		let yPos = objForSize.sprite.frame.height * CGFloat(atLayer)
		for index in 0 ..< totalSprites
		{
			let xPos = CGFloat(index) * objForSize.sprite.frame.width
			addGameObject( GroundObj( isTop: isTop , xStart: xPos, yStart: yPos ) )
		}
		
		return yPos
	}
	
	//creates the background image for the scene
	func createBackground()
	{
		let sprite = SKSpriteNode( imageNamed: "bg" )
        sprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
		sprite.size.height = frame.height
		sprite.size.width = frame.width
		sprite.zPosition = 1
		self.addChild( sprite )
	}
	
	func pairIsInArray( array : Array<(Int,Int)> , indexOne: Int, indexTwo: Int ) -> Bool
	{
		for element in array
		{
			if ( element.0 == indexOne && element.1 == indexTwo )
			{
				return true
			}
			
			if ( element.0 == indexTwo && element.1 == indexOne )
			{
				return true
			}
		}
		
		return false
	}
	
	func numberOfPlantObjects() -> Int
	{
		var toReturn : Int = 0
		for obj in gameObjects
		{
			if obj is PlantObj
			{
				toReturn += 1
			}
		}
		
		return toReturn
	}
	
	func getNearestPlantObj( x : CGFloat, y: CGFloat ) -> GameObj!
	{
		var toReturn : GameObj! = nil
		for obj in gameObjects
		{
			if ( obj is PlantObj )
			{
				if ( toReturn == nil )
				{
					toReturn = obj
				}
				else
				{
					//compare distances
					//if distance of current obj is better than toReturn, set toReturn=obj
					let currentMin = GameScene.distanceBetween( toReturn.sprite.position.x , y: toReturn.sprite.position.y , otherX: x , otherY: y )
					let potentialMin = GameScene.distanceBetween( obj.sprite.position.x , y: obj.sprite.position.y , otherX: x , otherY: y )
					if ( potentialMin < currentMin )
					{
						toReturn = obj
					}
				}
			}
		}
		
		return toReturn
	}

	//returns all GameObj instances currently in the scene of the type provided
	//does not return any objects of a subclass
	func allObjectsOfType( ofType : GameObj.Type ) -> Array<GameObj>
	{
		var toReturn = [GameObj]()
		for obj in gameObjects
		{
			if object_getClass( obj ) == ofType
			{
				toReturn.append( obj )
			}
		}
		
		return toReturn
	}
	
	//returns the hypotenuse distance between the two points provided
	static func distanceBetween( x : CGFloat, y: CGFloat, otherX : CGFloat, otherY: CGFloat ) -> Float
	{
		return hypotf(Float( x - otherX), Float( y - otherY ) )
	}
}
