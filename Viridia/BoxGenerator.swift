//
//  BoxGenerator.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/19/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class BoxGenerator : ObjGenerator
{	
	override init( screenWidth : CGFloat, screenHeight : CGFloat )
	{
		super.init( screenWidth: screenWidth , screenHeight: screenHeight )
		self.stepsNeeded = 80
		primePump()
	}
	
	override func generate() -> GameObj!
	{
		readyToGenerate = false
		let widthPad = roomWidth * 0.05
		let x = CGFloat(arc4random_uniform( UInt32(roomWidth - ( widthPad * 2 ) ) )) + widthPad
		let middleHeight = roomHeight * 0.54
		let y = CGFloat(arc4random_uniform( UInt32( middleHeight ) ) ) + roomHeight
		let newObj = BoxObj( spriteName: "box" , xStart: x, yStart: y )
		return newObj
	}
}