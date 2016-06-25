//
//  BoxObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/19/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class BoxObj : GameObj
{
	var generatedBy : BoxGenerator!
	
	override init(spriteName: String, xStart: CGFloat, yStart: CGFloat)
	{
		super.init( spriteName: spriteName, xStart: xStart, yStart: yStart )
		self.dieOnCollide = true
		self.dieOutsideScreen = true
		self.verSpeed = -120.0
		self.sprite.zPosition = 10
	}
	
	override func outsideRoomEvent( roomHeight : CGFloat, roomWidth : CGFloat )
	{
		if ( !dieOutsideScreen )
		{
			return
		}
		
		if ( sprite.position.y >= roomHeight )
		{
			return
		}
		
		makeDead()
	}
	
	override func deleteEvent(scene: GameScene) -> GameObj
	{
		super.deleteEvent( scene )
		if ( generatedBy != nil )
		{
				generatedBy!.generatedLost += 1
		}
		return self
	}

	
	override func dragEvent(location: CGPoint)
	{
		jumpTo( location.x, y: sprite.position.y  )
	}
	
	override func stopDragEvent(location: CGPoint)
	{
		jumpTo( location.x, y: sprite.position.y  )
	}
}
