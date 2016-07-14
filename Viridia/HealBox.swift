//
//  HealBox.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/20/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class HealBox : BoxObj
{
	init( xStart: CGFloat, yStart: CGFloat )
	{
		super.init(spriteName: "box", xStart: xStart, yStart: yStart)
	}
	
	override func collideEvent( other : GameObj )
	{
		if ( self.dieOnCollide && other.hasCollideEffect( self ) )
		{
			if ( other is BoxObj )
			{
				makeExplosion( self, spriteName: "explodeGrass" )
				onBoxHitsAnother( other as! BoxObj )
			}
			
			if ( other is GroundObj )
			{
				let otherGround = ( other as! GroundObj )
				if ( otherGround.isShroomed && !otherGround.isSandy )
				{
					other.makeExplosion( self, spriteName: "explodeGrass" )
				}
				otherGround.healMe()
			}
			
			self.makeDead()
		}
	}
}