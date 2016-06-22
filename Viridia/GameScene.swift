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
//	Fire plant
//		(DONE)shoots fire balls upwards when tapped
//		(DONE)any boxes hit by fire gets destroyed
//		(DONE)has a cool down period
//		fireballs need to be positioned correctly based on center of both sprites...
//		fireballs should disappear when hitting a box
//		if a bomb box hits this plant, the plant goes to cool down state
//	power up boxes that have specific powers
//		regenerate hurt plants(DONE)
//		build up rocks(creating a rock if it does not exist)
//	explode animation for when box hits ground, sand spilling out/spores
//	explode animation for when fireball hits a box
//	step counter for generators should be based off seconds * framesPerSecond for readability
//	(?)mycelium infestation from mushrooms that spread to nearby grass and turns to mycelium, turning more plants to shrooms
//	if the box hits sand, need some thing to happen that makes it not worthwhile to just continually drop boxes on sand
//		maybe spread the sand to adjacent tiles?
//		random sand monster that drags bomb to nearest grass tile touching the sand
//	need to make sure that there are at least a certain number of plants/rocks randomly generated
//		should have at least one fire plant
//	need user completing level correctly
//		i.e total time has passed certain point, or total number of boxes spawned has reached certain point
//			see winCondition function for basis of implementation
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
		generatorList.append( BoxGenerator( screenWidth: self.frame.width, screenHeight: self.frame.height ) )
		generatorList.append( CloudGenerator( screenWidth: self.frame.width, screenHeight: self.frame.height ) )
	}
	
	//creates a layer of sprites across the bottom of the screen
	private func createLayer( isTop: Bool, atLayer: Int )
	{
		let objForSize = GroundObj( isTop: isTop , xStart: 0, yStart: 0 )
		let totalSprites = Int( ceil( self.frame.width / objForSize.sprite.frame.width ) ) + 1
		for index in 0 ..< totalSprites
		{
			let yPos = objForSize.sprite.frame.height * CGFloat(atLayer)
			let xPos = CGFloat(index) * objForSize.sprite.frame.width
			addGameObject( GroundObj( isTop: isTop , xStart: xPos, yStart: yPos ) )
		}
		
		let total = numberOfObjects( PlantObj )
		print( "Total plants: \(total)" )
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
}
