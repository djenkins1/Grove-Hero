//
//  LevelScene.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/28/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import SpriteKit
import AVFoundation

class LevelScene : GameScene
{
	//whether the lose condition should be checked on update or not
	var shouldCheckLose = false
	
	override func didMoveToView(view: SKView)
	{
		notifyVictory = true
		createBackground()
		setupGenerators()
		createLayer( false , atLayer: 1 )
		createLayer( true , atLayer: 2 )
		generateScenery()
		setupVictory()
		shouldCheckLose = true
		addGameObject( PauseObj() )
	}
	
	private func setupVictory()
	{
		if ( myController != nil )
		{
			myController.victoryCond.startLevel( self )
		}
		else
		{
			print( "BAD VICTORY SETUP" )
		}
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		if ( pauseUpdate && doneScreen && myController != nil )
		{
			myController.changeState( GameState.Menu )
			return
		}
		
		if ( pauseUpdate )
		{
			//pauseUpdate = false
			return
		}
		
		super.touchesBegan( touches, withEvent: event )
	}
	
	override func didFinishUpdate()
	{
		if ( pauseUpdate )
		{
			return
		}
		
		checkWin()
		if ( shouldCheckLose )
		{
			checkLoseCondition()
		}
	}
	
	//adds all the generators
	func setupGenerators()
	{
		generatorList.append( BoxGenerator( screenWidth: self.frame.width, screenHeight: self.frame.height ).createEvent(self) )
		generatorList.append( CloudGenerator( screenWidth: self.frame.width, screenHeight: self.frame.height ).createEvent(self) )
	}
	
	func getScore() -> Int
	{
		let myPlants = allObjectsOfType( PlantObj )
		var shroomCount = 0
		for plant in myPlants
		{
			if ( ( plant as! PlantObj ).isShroom )
			{
				shroomCount += 1
			}
		}
		
		let plantCount = myPlants.count - shroomCount
		let fireCount = allObjectsOfType( FirePlant ).count
		
		var toReturn = 0
		toReturn += shroomCount * 1
		toReturn += plantCount * 5
		toReturn += fireCount * 10
		
		let allGround = allObjectsOfType( GroundObj )
		var shroomTileCount = 0
		var grassTileCount = 0
		for ground in allGround
		{
			if ( ground is GroundObj )
			{
				let myGround = ( ground as! GroundObj )
				if myGround.isTop
				{
					shroomTileCount += ( myGround.isShroomed && !myGround.isSandy ? 1 : 0 )
					grassTileCount += ( !myGround.isShroomed && !myGround.isSandy ? 1 : 0 )
				}
			}
		}
		
		toReturn += shroomTileCount * 2
		toReturn += grassTileCount * 5
		
		return toReturn
	}

	private func checkWin()
	{
		//let totalToGenerate = 15
		//let generatedLost = objectsDestroyed[ BombBox( xStart: 0, yStart: 0).className() ]
		if ( myController != nil )
		{
			if ( myController.victoryCond.hasWon( self ) )
			{
				winCondition()
			}
		}
	}
	
	//checks whether the player has lost the current level and does accordingly
	func checkLoseCondition()
	{
		if ( numberOfPlantObjects() == 0 )
		{
			self.playSoundEffect( Sounds.loseSound )
			pauseAndShowMessage( "Game Over!" )
			doneScreen = true
		}
	}
	
	//should be called when the player has won the current level
	func winCondition()
	{
		self.playSoundEffect( Sounds.winSound )
		pauseAndShowMessage( "You Won!", subMessage: "Score: \(getScore())" )
		doneScreen = true
	}
}