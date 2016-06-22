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
			if ( other is GroundObj )
			{
				(other as! GroundObj).healMe()
			}
			self.makeDead()
		}
	}
}