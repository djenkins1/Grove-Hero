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
	
	init( xStart: CGFloat, yStart: CGFloat )
	{
		super.init( spriteName: "rock3" , xStart: xStart, yStart: yStart )
		sprite.zPosition = 5
	}
	
	override func collideEvent(other: GameObj)
	{
		if other is BombBox
		{
			decrementLives()
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
}