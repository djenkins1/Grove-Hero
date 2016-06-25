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
//	(SCRAP)mycelium infestation from mushrooms that spread to nearby grass and turns to mycelium, turning more plants to shrooms
//	difficulty or configuration object that has constants, i.e spawn rate/number of plants generated
//	heal box should also plant a plant(only one) when it hits empty ground
//	heal box should turn regular plants into fireplants(only one) when hits grassy ground
//	(EDIT SPRITE)rock being built up animation for when rock gets hit by rock box
//	(NEED SPRITE)explode animation for when box hits ground, sand spilling out/spores
//	(NEED SPRITE)explode animation for when fireball hits a box
//	(NEED SPRITE)sand bugs that spawn out of sand and try to eat plants/shrooms nearby
//		will spawn immediately after a explosive box hits sandy ground
//		maybe tapping on them kills them?
//	(NEED/EDIT SPRITE)More accurate portrayal of boxes so that what is inside them has an icon of it
//	(?)should boxes be hidden by clouds(i.e zposition smaller than clouds)
//	(?)should cacti only be on sand?
//		i.e have shrooms turn into cacti?
//	(?)step counter for generators should be based off seconds * framesPerSecond for readability
//	(?)collisions should be based on non-transparent parts of the sprite
//		see GameObj init code for more info
//	firePlants should have lives like rocks, if hit by bombs too much should die
//		(EDIT SPRITE)should wither a bit when hit, i.e sprite change like rocks
//		should be healed by HealBoxes, also fires up the plant so that it is ready to fire
//	need app icon
//	need app name
//	need music
//	need sound effects
//		(Also need to add into engine, probably use code from Gemicus unless spritekit has better?)
//		boxes smashing against each other
//		boxes burning against flames
//		fire plant getting hit by bomb box
//		rock getting hit by bomb box and losing a life
//		rock getting hit by bomb box and being destroyed
//		rock jutting upwards when rock box hits ground
//		bomb crate smashing against rock
//		heal crate healing mycelium to grass
//			heal crate turning shrooms to plants
//		rock crate rebuilding rock lives when hits
//		bomb crate smashing against grass and creating mycelium
//			bomb crate turning plants into shrooms
//		bomb crate smashing against mycelium and creating sand
//			bomb crate killing off shrooms
//		bomb crate smashing against sand(unleash the sand monster SFX) 
//		sucess sound effect for winning level
//		failure sound effect for losing level
//	need menu screen
//		have gui buttons
//	(?)need splash screen
//		show title, tap to show menu
//	time attack mode that wins after certain amount of time
//	should have less of a delay with win screen after last box dies
//	maybe have totalGenerated be an array of boxobj types generated in BoxGenerator
//	lose level animation, rocks all get destroyed and turns into desolate sandy wasteland
//		maybe have a dead twiggy brush thing(western) blow across the screen
//
//==========
//

import SpriteKit

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
	
	var pauseUpdate = false
	
	var shouldCheckLose = false
	
	var objCreateQueue = [GameObj]()
	
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
		createBackground()
		setupGenerators()
		createLayer( false , atLayer: 1 )
		createLayer( true , atLayer: 2 )
		generateScenery()
		shouldCheckLose = true
    }
	

	
	/* Called before each frame is rendered */
	override func update(currentTime: CFTimeInterval)
	{
		if ( pauseUpdate )
		{
			return
		}
		
		if ( shouldCheckLose )
		{
			checkLoseCondition()
		}
		
		//get the difference in time from last time
		let deltaTime = currentTime - lastTime
		let currentFPS = Int( floor( 1 / deltaTime ) )
		lastTime = currentTime
		
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
	private func checkCollide()
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
				obj.collideEvent( other )
				other.collideEvent( obj )
			}
		}
	}
	
	
	func pauseAndShowMessage( message : String )
	{
		if ( pauseUpdate )
		{
			return
		}
		
		pauseUpdate = true
		let myLabel = SKLabelNode(fontNamed:"Chalkduster")
		myLabel.text = message
		myLabel.fontSize = 45
		myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
		myLabel.zPosition = 100
		myLabel.fontColor = UIColor.blackColor()
		self.addChild(myLabel)
	}
	
	//checks whether the player has lost the current level and does accordingly
	private func checkLoseCondition()
	{
		if ( numberOfObjects( PlantObj ) == 0 )
		{
			pauseAndShowMessage( "Game Over!" )
		}
	}
	
	//should be called when the player has won the current level
	func winCondition()
	{
		pauseAndShowMessage( "You Won!" )
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
	func removeGameObject( obj : GameObj )
	{
		obj.deleteEvent( self )
		self.removeChildrenInArray( [ obj.sprite ])
	}
	
	//adds the object and its sprite to the game view data, returns obj for chaining
	func addGameObject( obj : GameObj ) -> GameObj
	{
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
	
	//adds all the generators
	private func setupGenerators()
	{
		generatorList.append( BoxGenerator( screenWidth: self.frame.width, screenHeight: self.frame.height ).createEvent(self) )
		generatorList.append( CloudGenerator( screenWidth: self.frame.width, screenHeight: self.frame.height ).createEvent(self) )
	}
	
	//creates a layer of sprites across the bottom of the screen
	private func createLayer( isTop: Bool, atLayer: Int ) -> CGFloat
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
	private func createBackground()
	{
		let sprite = SKSpriteNode( imageNamed: "bg" )
        sprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
		sprite.size.height = frame.height
		sprite.size.width = frame.width
		sprite.zPosition = 1
		self.addChild( sprite )
	}
	
	private func pairIsInArray( array : Array<(Int,Int)> , indexOne: Int, indexTwo: Int ) -> Bool
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
	
	func numberOfObjects( ofType : GameObj.Type ) -> Int
	{
		var toReturn : Int = 0
		for obj in gameObjects
		{
			if object_getClass( obj ) == ofType
			{
				toReturn += 1
			}
		}
		
		return toReturn
	}

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
	
	private func generateScenery()
	{
		var numberOfRocks = 2
		var numberOfPlants = 5//TODO :Should be based off number of ground that are isTop
		var numberOfFires = 2
		let allGround = allObjectsOfType( GroundObj )
		var remainingTopGround = [GroundObj]()
		for obj in allGround
		{
			if ( obj is GroundObj && ( obj as! GroundObj).isTop )
			{
				remainingTopGround.append( (obj as! GroundObj) )
			}
		}
		
		while( remainingTopGround.count > 0 )
		{
			let randomIndex = Int( arc4random_uniform( UInt32( remainingTopGround.count ) ) )
			let myGround = remainingTopGround[ randomIndex ]
			remainingTopGround.removeAtIndex( randomIndex )
			
			if ( numberOfRocks > 0 )
			{
				let rockObj = RockObj(xStart: myGround.sprite.position.x, yStart: myGround.sprite.position.y )
				rockObj.sprite.position.y += rockObj.sprite.frame.height
				addGameObject( rockObj )
				numberOfRocks -= 1
				continue
			}
			else if ( numberOfPlants > 0 )
			{
				myGround.myPlant = PlantObj(xStart: myGround.sprite.position.x, yStart: myGround.sprite.position.y )
				myGround.myPlant!.sprite.position.y += myGround.myPlant!.sprite.frame.height
				addGameObject( myGround.myPlant! )
				numberOfPlants -= 1
				continue
			}
			else if ( numberOfFires > 0 )
			{
				myGround.myPlant = FirePlant(xStart: myGround.sprite.position.x, yStart: myGround.sprite.position.y )
				myGround.myPlant!.sprite.position.y += myGround.myPlant!.sprite.frame.height - 32
				addGameObject( myGround.myPlant! )
				numberOfFires -= 1
				continue
			}
			else
			{
				break
			}
		}
	}
	
}
