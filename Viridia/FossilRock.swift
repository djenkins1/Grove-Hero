//
//  FossilRock.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/15/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class FossilRock : RockObj
{
	override init(spriteName: String, xStart: CGFloat, yStart: CGFloat)
	{
		super.init( spriteName : spriteName, xStart: xStart, yStart: yStart )
		lives = 1
		self.sprite.zPosition = 21
	}
	
	//fossils should crack when a rockBox tries to heal them to full
	override func healToFull()
	{
		decrementLives()
	}
	
	override func incrementLives()
	{
		return
	}
}