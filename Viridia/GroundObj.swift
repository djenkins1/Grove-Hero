//
//  GroundObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/19/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class GroundObj : GameObj
{
	init( isTop : Bool, xStart: CGFloat, yStart: CGFloat )
	{
		super.init( spriteName: GroundObj.getSprite( isTop ) , xStart: xStart, yStart: yStart )
	}
	
	static func getSprite( isTop : Bool ) -> String
	{
		return ( isTop ? "grassMid" : "grassCenter" )
	}
}
