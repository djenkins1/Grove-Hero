//
//  RockObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/20/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class RockObj : GameObj
{
	var lives : Int = 3
	
	var collideSteps = 0
	
	convenience init( xStart: CGFloat, yStart: CGFloat )
	{
		self.init( spriteName: "rock3" , xStart: xStart, yStart: yStart )
	}
	
	override init( spriteName : String, xStart: CGFloat, yStart: CGFloat )
	{
		super.init( spriteName: spriteName, xStart: xStart, yStart: yStart )
		sprite.zPosition = 5
	}
	
	override func collideEvent(other: GameObj)
	{
		if other is BombBox && collideSteps == 0
		{
			makeExplosion( self , spriteName: "explodeSand" )
			decrementLives()
			//add a step delay so that the bombBox does not double dip and cause this rock to lose 2 lives
			collideSteps = 4
		}
		
	}
	
	override func updateEvent(scene: GameScene, currentFPS: Int)
	{
		super.updateEvent( scene , currentFPS: currentFPS )
		if ( collideSteps > 0 )
		{
			collideSteps -= 1
		}
	}
	
	func decrementLives()
	{
		lives = lives - 1
		if ( lives <= 0 )
		{
			if ( myScene != nil )
			{
				myScene!.playSoundEffect( Sounds.deadRock )
			}
			makeDead()
		}
		else
		{
			if ( myScene != nil )
			{
				myScene!.playSoundEffect( Sounds.lostRock )
			}
			changeSprite( "rock\(lives)" )
		}
	}
	
	func incrementLives()
	{
		if ( myScene != nil )
		{
			myScene!.playSoundEffect( Sounds.rockLives )
		}
		
		lives = lives + 1
		if ( lives > 3 )
		{
			lives = 3
		}
		changeSprite( "rock\(lives)" )
	}
	
	func healToFull()
	{
		if ( myScene != nil )
		{
			myScene!.playSoundEffect( Sounds.rockLives )
		}
		
		lives = 3
		changeSprite( "rock\(lives)" )
	}
}