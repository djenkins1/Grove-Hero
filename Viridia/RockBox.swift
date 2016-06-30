//
//  RockBox.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/24/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class RockBox : BoxObj
{
	private var rockedOut = false
	
	init( xStart: CGFloat, yStart: CGFloat )
	{
		super.init(spriteName: "boxAlt", xStart: xStart, yStart: yStart)
	}
	
	override func collideEvent( other : GameObj )
	{
		if ( rockedOut )
		{
			self.makeDead()
			return
		}
		
		if ( self.dieOnCollide && other.hasCollideEffect( self ) )
		{
			if ( other is RockObj )
			{
				( other as! RockObj).incrementLives()
				rockedOut = true
			}
			else if ( other is GroundObj )
			{
				(other as! GroundObj).rockMe()
				rockedOut = true
			}
			else if ( other is BoxObj )
			{
				onBoxHitsAnother( other as! BoxObj )
				rockedOut = true
			}
			
			self.makeDead()
		}
	}
}
