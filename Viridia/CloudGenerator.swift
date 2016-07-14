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
		self.secondsNeeded = 2
		primePump()
	}
	
	override func generate() -> GameObj!
	{
		readyToGenerate = false
		
		return createCloudAt( randomX(), y: randomY() )
	}
	
	override func entryGenerate() -> ObjGenerator
	{
		let cloudsToGenerate = 5
		for _ in 0 ..< cloudsToGenerate
		{
			scene.queueGameObject( createCloudAt( randomInsideX(), y : randomY() ) )
		}
		
		return self
	}
	
	private func randomInsideX() -> CGFloat
	{
		return CGFloat(arc4random_uniform( UInt32( roomWidth ))) + ( roomWidth * 0.25 )
	}
	
	private func randomX() -> CGFloat
	{
		return CGFloat(arc4random_uniform( UInt32( roomWidth ))) + roomWidth
	}
	
	private func randomY() -> CGFloat
	{
		let middleHeight = roomHeight * 0.54
		return CGFloat(arc4random_uniform( UInt32( roomHeight - middleHeight ) ) ) + middleHeight
	}
	
	private func createCloudAt( x : CGFloat, y: CGFloat ) -> CloudObj
	{
		let newObj = CloudObj( xStart: x, yStart: y )
		let lowestX = newObj.sprite.frame.width * -1.5
		let highestX = roomWidth * 2
		newObj.myPath = GamePath(x: lowestX, y: y, speedInSeconds: 25, startX: highestX, startY: y )
		newObj.myPath!.adjustSpeed( newObj, otherThanZero: true )
		return newObj
	}
}