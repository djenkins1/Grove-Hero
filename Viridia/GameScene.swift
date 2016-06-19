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
//	when box hits ground, should fire off code that causes damage
//	rocks that have # of lives, lose life and get smaller when hit by boxes
//	some other scenic object that eats boxes but has to wait so much time before next box can be eaten
//		have placeholder door sprite, top should change over from black to wood when eating
//	power up boxes that have specific powers, i.e regenerate hurt plants, build up rocks
//	special plant that shoots burst of sun ray upwards when tapped, any boxes hit by ray get destroyed
//	cloud objects that get generated 
//	(BUG)Grass/Ground should not be able to be dragged like boxes
//==========
//

import SpriteKit

class GameScene: SKScene
{
	var gameObjects = [GameObj]()
	var lastTime : CFTimeInterval = 0
	var objectTouched : GameObj!
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
		setupGenerators()
		createLayer( "grassCenter" , atLayer: 1 )
		createLayer( "grassMid" , atLayer: 2 )
    }
	
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
       /* Called when a touch begins */
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
			objectTouched.jumpTo( location.x, y: objectTouched.sprite.position.y  )
		}
	}
	
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
			objectTouched.jumpTo( location.x, y: objectTouched.sprite.position.y )
			objectTouched = nil
		}
	}
	
	//checks for collisions in all objects and makes objects dead if they collide and dieOnCollide is true for said obj
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
				obj.outsideRoomEvent( frame.height )
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
	
	/*
	func createRandomBoxObject()
	{
		let sprite = SKSpriteNode(imageNamed:"box")
		let widthPad = self.frame.width * 0.05
		let x = CGFloat(arc4random_uniform( UInt32(self.frame.width - ( widthPad * 2 ) ) )) + widthPad
		let middleHeight = self.frame.height * 0.54
		let y = CGFloat(arc4random_uniform( UInt32( middleHeight ) ) ) + self.frame.height
		sprite.position = CGPoint( x:x, y:y )
		let newObj = GameObj( spriteName: "box" , xStart: x, yStart: y )
		newObj.horSpeed = 0.0
		newObj.verSpeed = -120.0
		newObj.dieOutsideScreen = true
		newObj.dieOnCollide = true
		addGameObject( newObj )
	}
	*/
	
	private func setupGenerators()
	{
		generatorList.append( BoxGenerator( screenWidth: self.frame.width, screenHeight: self.frame.height ) )
	}
	
	
	private func createLayer( spriteName: String, atLayer: Int )
	{
		let objForSize = GameObj( spriteName: spriteName , xStart: 0, yStart: 0 )
		let totalSprites = Int( ceil( self.frame.width / objForSize.sprite.frame.width ) ) + 1
		for index in 0 ..< totalSprites
		{
			let yPos = objForSize.sprite.frame.height * CGFloat(atLayer)
			let xPos = CGFloat(index) * objForSize.sprite.frame.width
			addGameObject( GameObj( spriteName: spriteName , xStart: xPos, yStart: yPos ) )
		}
	}
}
