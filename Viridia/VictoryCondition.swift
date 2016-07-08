//
//  VictoryCondition.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/4/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

protocol VictoryCondition
{
	func hasWon( scene : GameScene ) -> Bool
	
	func secondPassed( scene : GameScene )
	
	func startLevel( scene : GameScene )
}

class BoxVictory : VictoryCondition
{
	func hasWon( scene : GameScene ) -> Bool
	{
		let totalToGenerate = 15
		let generatedLost = scene.objectsDestroyed[ BombBox( xStart: 0, yStart: 0).className() ]
		return ( generatedLost != nil && generatedLost >= totalToGenerate)
	}
	
	func secondPassed( scene : GameScene )
	{
		return
	}
	
	func startLevel(scene: GameScene)
	{
		return
	}
}

class TimeVictory : VictoryCondition
{
	var timerLabel : SKLabelNode!
	
	func hasWon( scene : GameScene ) -> Bool
	{
		return ( scene.secondsPlayed >= finishTimeSeconds() )
	}
	
	func startLevel( scene : GameScene )
	{
		let fontSize : CGFloat = 35
		let paddingHeight = scene.frame.height * 0.2
		timerLabel = scene.addMakeLabel( timerClockLeft( 0 ), xPos: max( scene.frame.width * 0.1, fontSize ), yPos: scene.frame.height - fontSize - paddingHeight, fontSize: fontSize)
	}
	
	func secondPassed( scene : GameScene )
	{
		if ( timerLabel != nil )
		{
			timerLabel.text = timerClockLeft( scene.secondsPlayed )
		}

	}
	
	private func finishTimeSeconds() -> Int
	{
		return 60
	}
	
	private func timerClockLeft( timePassed : Int ) -> String
	{
		let timeLeft = finishTimeSeconds() - timePassed
		return convertTimerTime( timeLeft )

	}
	
	//converts the integer value provided to a clock value of format mm:ss
	private func convertTimerTime( time : Int ) -> String
	{
		let minutes = time / 60
		let seconds = time % 60
		var toReturn = ""
		if ( minutes < 10 )
		{
			toReturn.append( "0" as Character )
		}
		toReturn = toReturn + String(minutes) + ":"
		
		if ( seconds < 10 )
		{
			toReturn.append( "0" as Character )
		}
		toReturn = toReturn + String( seconds )
		
		return toReturn
	}
}