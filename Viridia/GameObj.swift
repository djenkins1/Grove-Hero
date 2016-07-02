//
//  GameObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/17/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class GameObj
{
	//an identifier representing this object
	var id : Int!
	
	//the sprite that is drawn by this object
	var sprite : SKSpriteNode
	
	//the horizontal speed of this object in pixels/second, negative for moving to the left
	var horSpeed : CGFloat = 0.0
	
	//the vertical speed of this object in pixels/second, negative for moving downwards
	var verSpeed : CGFloat = 0.0
	
	//this is set to true when the object should no longer function and be deleted
	var isDead = false
	
	//whether the object should set isDead to true if the sprites position is outside the screen
	var dieOutsideScreen = false
	
	//whether the object should die when another object collides with it
	var dieOnCollide = false
	
	var myScene : GameScene!
	
	var myPath : GamePath!
	
	let mySprites : SpriteRoll
	
	init( spriteName : String, xStart : CGFloat, yStart : CGFloat )
	{
		mySprites = SpriteRoll()
		mySprites.withImages( [ spriteName ] )
		sprite = SKSpriteNode( imageNamed: spriteName )
		sprite.position = CGPoint( x: xStart, y: yStart )
		sprite.anchorPoint = CGPoint( x: 0.0, y: 0.0 )
		sprite.zPosition = 10
		
		//this should take transparency into account for collisions?
		//	also needs to rewrite collision, see bookmarks for bombz
		//sprite.physicsBody = SKPhysicsBody( texture: sprite.texture! , size: sprite.texture!.size() )
	}
	
	//moves the sprite based on horSpeed and verSpeed adjusted to framesPerSecond
	func move( framesPerSecond : Int ) -> GameObj
	{
		if ( myPath != nil )
		{
			if ( !( myPath!.adjustSpeed( self ) ) )
			{
				myPath = nil
			}
		}
		
		if ( horSpeed == 0 && verSpeed == 0 )
		{
			return self
		}
		
		let horSpeedFrame = horSpeed / CGFloat( framesPerSecond )
		let verSpeedFrame = verSpeed / CGFloat( framesPerSecond )
		if ( horSpeedFrame == 0 && verSpeedFrame == 0 )
		{
			return self
		}
		
		let xCurrent = self.sprite.position.x
		let yCurrent = self.sprite.position.y
		self.sprite.position.x = xCurrent + horSpeedFrame
		self.sprite.position.y = yCurrent + verSpeedFrame
		return self
	}
	
	//called when the object is being added to the scene, should return itself
	func createEvent( scene : GameScene ) -> GameObj
	{
		myScene = scene
		return self
	}
	
	//called when the object is being removed from the scene, should return itself
	func deleteEvent( scene : GameScene ) -> GameObj
	{
		makeDead()
		return self
	}
	
	//returns true if the x and y position of the sprite are within the boundaries specified
	func checkPositionToBoundaries( xEnd : CGFloat, yEnd: CGFloat ) -> Bool
	{
		return ( checkBoundary( sprite.position.x, minValue: 0, maxValue: xEnd) && checkBoundary( sprite.position.y,  minValue: 0, maxValue: yEnd ))
	}
	
	//returns true if myValue given is within the boundaries of 0 and the maxValue
	private func checkBoundary( myValue : CGFloat, minValue: CGFloat, maxValue: CGFloat ) -> Bool
	{
		return ( myValue >= 0 && myValue <= maxValue )
	}
	
	//returns true if the two objects do collide based on their width/height and current positions
	func doesCollide( otherObj : GameObj ) -> Bool
	{
		return sprite.frame.intersects( otherObj.sprite.frame )
	}
	
	//simply makes the object dead
	//to actually call code when the object is removed from the scene see deleteEvent(:_)
	final func makeDead()
	{
		if ( isDead )
		{
			return
		}
		self.isDead = true
	}
	
	//moves the objects sprite instantly to the coordinates provided
	func jumpTo( x: CGFloat, y: CGFloat )
	{
		self.sprite.position.x = x
		self.sprite.position.y = y
	}
	
	//fires when this object is considered outside the screen
	func outsideRoomEvent( roomHeight : CGFloat, roomWidth : CGFloat )
	{
		if ( !dieOutsideScreen )
		{
			return
		}

		makeDead()
	}
	
	//fires when this object collides with another object
	func collideEvent( other : GameObj )
	{
		if ( self.dieOnCollide )
		{
			self.makeDead()
		}
	}
	
	//fires when the object is touched
	func touchEvent( location : CGPoint )
	{
		
	}
	
	//fires when the object is no longer being touched
	func stopDragEvent( location: CGPoint )
	{
		
	}
	
	//fires when the object is being dragged by touch
	func dragEvent( location: CGPoint )
	{
		
	}
	
	//changes the sprite's current texture to the spriteName provided
	func changeSprite( spriteName : String )
	{
		sprite.texture = SKTexture(imageNamed: spriteName )
	}
	
	//fires when the update function is called in the GameScene
	func updateEvent( scene : GameScene, currentFPS : Int )
	{
		if ( mySprites.animate( currentFPS ) )
		{
			if let newSprite = mySprites.getCurrentImageString()
			{
				changeSprite( newSprite )
			}
			else
			{
				print( "Could not change to sprite for \(self)" )
			}
		}
	}
	
	func hasCollideEffect( other : GameObj ) -> Bool
	{
		return true
	}
	
	func withID( id : Int ) -> GameObj
	{
		self.id = id
		return self
	}
}