//
//  CloudGenerator.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/19/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class CloudGenerator : ObjGenerator
{
	override init( screenWidth : CGFloat, screenHeight : CGFloat )
	{
		super.init( screenWidth: screenWidth , screenHeight: screenHeight )
		self.stepsNeeded = 120
		primePump()
	}
	
	override func generate() -> GameObj!
	{
		totalGenerated += 1
		readyToGenerate = false
		let x = CGFloat(arc4random_uniform( UInt32( roomWidth ))) + roomWidth
		let middleHeight = roomHeight * 0.54
		let y = CGFloat(arc4random_uniform( UInt32( roomHeight - middleHeight ) ) ) + middleHeight
		let newObj = CloudObj( xStart: x, yStart: y )
		return newObj
	}
}