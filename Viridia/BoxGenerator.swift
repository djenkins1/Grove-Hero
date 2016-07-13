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
		if ( scene != nil && scene.myController != nil )
		{
			self.secondsNeeded = scene.myController.diffiCons.secondsBetweenSpawns
		}
		else
		{
			self.secondsNeeded = 1.2
		}
		primePump()
	}
	
	override func generate() -> GameObj!
	{
		var toReturn : BoxObj! = nil
		readyToGenerate = false
		
		if ( doSpawnBox() )
		{

			let widthPad = roomWidth * 0.05
			let x = CGFloat(arc4random_uniform( UInt32(roomWidth - ( widthPad * 2 ) ) )) + widthPad
			let middleHeight = roomHeight * 0.54
			let y = CGFloat(arc4random_uniform( UInt32( middleHeight ) ) ) + roomHeight
			
			
			let randomNum = arc4random_uniform( bombBoxChance() )
			if (  randomNum == 0 )
			{
				toReturn = HealBox( xStart: x, yStart: y )
			}
			else if ( randomNum == 1 )
			{
				toReturn = RockBox( xStart: x, yStart: y)
			}
			else
			{
				toReturn = BombBox( xStart: x, yStart: y )
				totalGenerated += 1
			}
			
			let highestY = middleHeight + roomHeight
			toReturn.myPath = GamePath( x: x, y: 0, speedInSeconds: scene!.myController!.diffiCons.boxSpeedInSeconds , startX: x, startY:  highestY )
			toReturn.myPath!.adjustSpeed( toReturn, otherThanZero: true )
		}
		
		return toReturn
	}
	
	private func doSpawnBox() -> Bool
	{
		var toReturn = false
		if ( scene != nil && scene.myController != nil )
		{
			toReturn = ( arc4random_uniform( scene.myController.diffiCons.boxSpawnRateHigh ) < scene.myController.diffiCons.boxSpawnRateLow )
		}
		else
		{
			toReturn = ( arc4random_uniform( 5 ) < 2 )
		}
		
		return toReturn
	}
	
	private func bombBoxChance() -> UInt32
	{
		var toReturn : UInt32 = 5
		if ( scene != nil )
		{
			toReturn = UInt32( scene.myController.diffiCons.boxChanceOfBomb )
		}

		return toReturn
	}
}