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
	var generatedLost : Int = 0
	
	let totalToGenerate : Int = 20
	
	override init( screenWidth : CGFloat, screenHeight : CGFloat )
	{
		super.init( screenWidth: screenWidth , screenHeight: screenHeight )
		self.stepsNeeded = 80
		primePump()
	}
	
	override func incrementSteps()
	{
		super.incrementSteps()
		checkWin()
	}
	
	override func generate() -> GameObj!
	{
		var toReturn : BoxObj! = nil
		readyToGenerate = false
		
		if ( totalGenerated >= totalToGenerate )
		{
			return nil
		}
		
		if ( arc4random_uniform( 5 ) < 2 )
		{

			let widthPad = roomWidth * 0.05
			let x = CGFloat(arc4random_uniform( UInt32(roomWidth - ( widthPad * 2 ) ) )) + widthPad
			let middleHeight = roomHeight * 0.54
			let y = CGFloat(arc4random_uniform( UInt32( middleHeight ) ) ) + roomHeight
			
			
			let randomNum = arc4random_uniform( 5 )
			if (  randomNum == 0 )
			{
				toReturn = HealBox(  xStart: x, yStart: y )
			}
			else if ( randomNum == 1 )
			{
				toReturn = RockBox(xStart: x, yStart: y)
			}
			else
			{
				toReturn = BombBox(  xStart: x, yStart: y )
				totalGenerated += 1
			}
			
			let highestY = middleHeight + roomHeight
			toReturn!.generatedBy = self
			toReturn.myPath = GamePath( x: x, y: 0, speedInSeconds: scene!.myController!.diffiCons.boxSpeedInSeconds , startX: x, startY:  highestY )
			toReturn.myPath!.adjustSpeed( toReturn, otherThanZero: true )
		}
		
		return toReturn
	}
	
	private func checkWin()
	{
		if ( generatedLost >= totalToGenerate && scene != nil )
		{
			scene!.winCondition()
		}
	}
}