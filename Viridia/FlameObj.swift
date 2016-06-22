//
//  FlameObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/21/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class FlameObj : GameObj
{
	init( xStart : CGFloat, yStart: CGFloat )
	{
		super.init( spriteName: "flame" , xStart: xStart, yStart: yStart )
		self.dieOnCollide = false
		self.dieOutsideScreen = true
		self.sprite.zPosition = 20
		self.verSpeed = 120
	}
}