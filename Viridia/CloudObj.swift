//
//  CloudObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/19/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class CloudObj : GameObj
{
	init( xStart: CGFloat, yStart: CGFloat)
	{
		let spriteName = CloudObj.randomCloudSprite()
		super.init( spriteName: spriteName, xStart: xStart, yStart: yStart )
		self.dieOnCollide = false
		self.dieOutsideScreen = true
		self.horSpeed = -60
		self.sprite.zPosition = 5
	}
	
	override func outsideRoomEvent( roomHeight : CGFloat, roomWidth : CGFloat )
	{
		if ( !dieOutsideScreen )
		{
			return
		}
		
		if ( horSpeed > 0 && sprite.position.x > roomWidth + sprite.frame.width )
		{
			//moving to the right and past right edge of screen
			makeDead()
		}
		else if ( horSpeed < 0 && sprite.position.x < 0 - sprite.frame.width )
		{
			//moving to the left and past left edge of screen
			makeDead()
		}
		

	}
	
	static func randomCloudSprite() -> String
	{
		let choices = [ 1 , 2 , 3 ]
		let myChoice = Int( arc4random_uniform( UInt32( choices.count ) ) )
		return "cloud\(choices[myChoice])"
	}
}