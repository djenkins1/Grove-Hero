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
//	Add in random plants
//		have random sprites chosen in PlantObj constructor, just need to position them on top of grass randomly grids
//	when box hits ground, should fire off code that causes damage
//	rocks that have # of lives, lose life and get smaller when hit by boxes
//	some other scenic object that eats boxes but has to wait so much time before next box can be eaten
//		have placeholder door sprite, top should change over from black to wood when eating
//	power up boxes that have specific powers, i.e regenerate hurt plants, build up rocks
//	special plant that shoots burst of sun ray upwards when tapped, any boxes hit by ray get destroyed
//	explode animation for when box hits ground
//	seperate explosiveBox object and other pickup boxes
//	step counter for generators should be based off seconds * framesPerSecond for readability
//	should the clouds be moving or stationary?
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
    }
	
	/* Called before each frame is rendered */
	override func update(currentTime: CFTimeInterval)
	{
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
		
			var innerIndex = -1
			for other in gameObjects
			{
				innerIndex = innerIndex + 1
				if innerIndex == outerIndex || obj.isDead || other.isDead
				{
					continue
				}
				
				if ( obj.doesCollide( other ) )
				{
					obj.collideEvent(other)
					other.collideEvent( obj )
				}
			}
		}
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
	private func removeGameObject( obj : GameObj )
	{
		obj.makeDead()
		self.removeChildrenInArray( [ obj.sprite ])
	}
	
	//adds the object and its sprite to the game view data, returns obj for chaining
	private func addGameObject( obj : GameObj ) -> GameObj
	{
		self.gameObjects.append( obj )
		self.addChild( obj.sprite )
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
}
