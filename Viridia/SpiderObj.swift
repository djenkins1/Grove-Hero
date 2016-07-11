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
	
	var haveChosenDirect = false

	
	init( xStart: CGFloat, yStart: CGFloat)
	{
		super.init( spriteName: "spiderL", xStart: xStart, yStart: yStart )
		self.dieOnCollide = true
		self.dieOutsideScreen = true
		self.sprite.zPosition = 1
	}
	
	override func createEvent(scene: GameScene) -> GameObj
	{
		super.createEvent( scene )
		secondsBetween = scene.myController!.diffiCons.spiderEatSpeedInSecs
		
		return self
		
	}
	
	private func speedAI()
	{
		if ( myScene == nil )
		{
			return
		}
		
		haveChosenDirect = true
		self.sprite.zPosition = 15
		let scene = myScene
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
				mySprites.withImages( [ "spiderRwalk1" , "spiderRwalk2" ] ).withImageSpeed( 0.25 ).syncImageOfObj( self )
			}
		}
		else
		{
			self.horSpeed = baseSpeed
		}
	}
	
	override func collideEvent(other: GameObj)
	{
		if ( isDead )
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
			makeDead( true )
		}
	}
	
	func makeDead( doDeathSound : Bool )
	{
		super.makeDead()
		if ( doDeathSound && myScene != nil )
		{
			myScene.playSoundEffect( Sounds.spiderDead )
		}
	}
	
	override func move(framesPerSecond: Int) -> GameObj
	{
		if ( notEating() )
		{
			super.move( framesPerSecond )
			if ( myPath == nil && !haveChosenDirect  )
			{
				speedAI()
			}
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
					self.makeDead( true )
				}
			}
		}
	}
	
	//fires when the object is touched
	override func touchEvent( location : CGPoint )
	{
		super.touchEvent( location )
		if ( myPath != nil )
		{
			return
		}
		
		if ( !isDead )
		{
			changeToDeathSprite()
			makeDead( true )
		}
	}
	
	private func changeToDeathSprite()
	{
		var mySprite = "spiderLdead"
		if ( horSpeed > 0 )
		{
			mySprite = "spiderRdead"
		}
		
		changeSprite( mySprite )
	}
	
	//fires when this object is considered outside the screen
	override func outsideRoomEvent( roomHeight : CGFloat, roomWidth : CGFloat )
	{
		let spriteLength = sprite.frame.width * 2
		if ( sprite.position.x < 0 - spriteLength )
		{
			makeDead( false )
		}
		else if ( sprite.position.x > roomWidth + spriteLength )
		{
			makeDead( false )
		}
	}
}