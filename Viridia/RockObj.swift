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
		super.init( spriteName: "rock" , xStart: xStart, yStart: yStart )
	}
	
	override func collideEvent(other: GameObj)
	{
		if other is BoxObj
		{
			decrementLives()
		}
		
	}
	
	func decrementLives()
	{
		lives = lives - 1
		if ( lives <= 0 )
		{
			makeDead()
		}
	}
}