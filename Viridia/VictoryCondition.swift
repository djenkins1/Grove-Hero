//
//  VictoryCondition.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/4/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

protocol SaveConstant
{
	func myName() -> String
}

protocol VictoryCondition : SaveConstant
{
	func hasWon( scene : GameScene ) -> Bool
	
	func startLevel( scene : GameScene )
	
	func updateEvent( scene : GameScene, currentFPS: Int )
}

class BoxVictory : VictoryCondition
{
	var countLabel : SKLabelNode!
	
	var counter : Int = 0
	
	func hasWon( scene : GameScene ) -> Bool
	{
		let generatedLost = scene.objectsDestroyed[ BombBox( xStart: 0, yStart: 0).className() ]
		return ( generatedLost != nil && generatedLost >= totalToGenerate() )
	}
	
	
	func startLevel(scene: GameScene)
	{
		counter = 0
		let yPos = scene.frame.height - 200
		let xPos : CGFloat = 60
		let sprite = scene.addMakeSprite( "boxExplosiveAlt" , xPos: xPos, yPos: yPos)
		let fontSize : CGFloat = 30
		countLabel = scene.addMakeLabel( "", xPos: xPos + sprite.frame.width + fontSize, yPos: yPos + ( sprite.frame.height * 0.38 ), fontSize: fontSize)
		updateCountLabel( totalToGenerate() )

	}
	
	func updateEvent( scene : GameScene, currentFPS: Int )
	{
		counter += 1
		if ( counter >= currentFPS / 6 )
		{
			counter = 0
			updateCountLabel( remainingBoxes( scene ) )
		}

		return
	}
	
	private func updateCountLabel( totalBoxesLeft : Int )
	{
		if ( totalBoxesLeft >= 0 && countLabel != nil )
		{
			countLabel.text = String( totalBoxesLeft )
		}
	}
	
	private func totalToGenerate() -> Int
	{
		return 15
	}
	
	private func remainingBoxes( scene : GameScene ) -> Int
	{
		let generatedLost = scene.objectsDestroyed[ BombBox( xStart: 0, yStart: 0).className() ]
		var total = 0
		if ( generatedLost != nil )
		{
			total = generatedLost!
		}
		
		return totalToGenerate() - total
	}
	
	func myName() -> String
	{
		return "Boxed"
	}
}

class TimeVictory : VictoryCondition
{
	var timerLabel : SKLabelNode!
	
	var currentTime : Int = 0
	
	var timeSteps : Int = 0
	
	func hasWon( scene : GameScene ) -> Bool
	{
		return ( currentTime >= finishTimeSeconds() )
	}
	
	func startLevel( scene : GameScene )
	{
		timeSteps = 0
		currentTime = 0
		let fontSize : CGFloat = 35
		let paddingHeight = scene.frame.height * 0.2
		timerLabel = scene.addMakeLabel( timerClockLeft( 0 ), xPos: max( scene.frame.width * 0.1, fontSize ), yPos: scene.frame.height - fontSize - paddingHeight, fontSize: fontSize)
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
		if ( time <= 0 )
		{
			return "00:00"
		}
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
	
	func updateEvent( scene : GameScene, currentFPS: Int )
	{
		timeSteps += 1
		if ( timeSteps >= currentFPS )
		{
			timeSteps = 0
			currentTime += 1
			updateClock()
		}
	}
	
	private func updateClock()
	{
		if ( timerLabel != nil )
		{
			timerLabel.text = timerClockLeft( currentTime )
		}
	}
	
	func myName() -> String
	{
		return "Timed"
	}
}