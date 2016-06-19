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
	let roomWidth : CGFloat
	let roomHeight : CGFloat
	
	init( screenWidth : CGFloat, screenHeight : CGFloat )
	{
		self.roomHeight = screenHeight
		self.roomWidth = screenWidth
		super.init()
		self.stepsNeeded = 80
	}
	
	override func generate() -> GameObj!
	{
		readyToGenerate = false
		let sprite = SKSpriteNode(imageNamed:"box")
		let widthPad = roomWidth * 0.05
		let x = CGFloat(arc4random_uniform( UInt32(roomWidth - ( widthPad * 2 ) ) )) + widthPad
		let middleHeight = roomHeight * 0.54
		let y = CGFloat(arc4random_uniform( UInt32( middleHeight ) ) ) + roomHeight
		sprite.position = CGPoint( x:x, y:y )
		let newObj = GameObj( spriteName: "box" , xStart: x, yStart: y )
		newObj.horSpeed = 0.0
		newObj.verSpeed = -120.0
		newObj.dieOutsideScreen = true
		newObj.dieOnCollide = true
		return newObj
	}
}