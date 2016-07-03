//
//  SpiderObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/29/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class SpiderObj : GameObj
{
	var currentEatenPlant : PlantObj! = nil
	
	var secondsBetween : CGFloat = 1.5
	
	var stepCounter : CGFloat = 0
	
	let baseSpeed : CGFloat = 180

	
	init( xStart: CGFloat, yStart: CGFloat)
	{
		super.init( spriteName: "spiderL", xStart: xStart, yStart: yStart )
		self.dieOnCollide = true
		self.dieOutsideScreen = true
		self.sprite.zPosition = 15
	}
	
	override func createEvent(scene: GameScene) -> GameObj
	{
		super.createEvent( scene )
		secondsBetween = scene.myController!.diffiCons.spiderEatSpeedInSecs
		
		let closestPlant = scene.getNearestPlantObj( sprite.position.x, y: sprite.position.y )
		if ( closestPlant != nil )
		{
			let spiderGoesLeft = closestPlant.sprite.position.x < sprite.position.x
			if ( spiderGoesLeft )
			{
				self.horSpeed = -baseSpeed
				mySprites.withImages( [ "spiderLwalk1" , "spiderLwalk2" ] ).withImageSpeed( 0.25 ).syncImageOfObj( self )
			}
			else
			{
				self.horSpeed = baseSpeed
				//changeSprite( "spiderR" )
				mySprites.withImages( [ "spiderRwalk1" , "spiderRwalk2" ] ).withImageSpeed( 0.25 ).syncImageOfObj( self )
			}
		}
		else
		{
			self.horSpeed = baseSpeed
		}
		
		return self
		
	}
	
	override func collideEvent(other: GameObj)
	{
		if ( isDead )
		{
			return
		}
		
		if ( other.isDead )
		{
			return
		}
	
		if other is PlantObj && notEating()
		{
			stepCounter = 0
			currentEatenPlant = ( other as! PlantObj)
		}
		
		if other is BoxObj
		{
			makeDead()
		}
	}
	
	override func move(framesPerSecond: Int) -> GameObj
	{
		if ( notEating() )
		{
			super.move( framesPerSecond )
		}
		else
		{
			//should change sprite roll images to not moving
		}
		
		return self
	}

	func notEating() -> Bool
	{
		if ( currentEatenPlant == nil || currentEatenPlant!.isDead )
		{
			currentEatenPlant = nil
			return true
		}
		
		return false
	}
	
	//fires when the update function is called in the GameScene
	override func updateEvent( scene : GameScene, currentFPS : Int )
	{
		super.updateEvent(scene, currentFPS: currentFPS )
		if ( notEating() )
		{
			stepCounter = 0
			return
		}
		
		stepCounter += 1
		let stepsNeeded = CGFloat( currentFPS ) * secondsBetween
		if ( stepCounter >= stepsNeeded )
		{
			stepCounter = 0
			if ( currentEatenPlant != nil )
			{
				currentEatenPlant!.damage()
				if ( currentEatenPlant is FirePlant )
				{
					self.makeDead()
				}
			}
		}
	}
	
	//fires when the object is touched
	override func touchEvent( location : CGPoint )
	{
		super.touchEvent( location )
		if ( !isDead )
		{
			makeDead()
		}
	}
	
	//fires when this object is considered outside the screen
	override func outsideRoomEvent( roomHeight : CGFloat, roomWidth : CGFloat )
	{
		let spriteLength = sprite.frame.width * 2
		if ( sprite.position.x < 0 - spriteLength )
		{
			makeDead()
		}
		else if ( sprite.position.x > roomWidth + spriteLength )
		{
			makeDead()
		}
	}
}