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
	
	func generateScenery()
	{
		let allGround = allObjectsOfType( GroundObj )
		var remainingTopGround = [GroundObj]()
		for obj in allGround
		{
			if ( obj is GroundObj && ( obj as! GroundObj).isTop )
			{
				remainingTopGround.append( (obj as! GroundObj) )
			}
		}
		
		var index = -1
		var rightMostIndex = 0
		for obj in remainingTopGround
		{
			index += 1
			if ( obj.sprite.position.x > remainingTopGround[ rightMostIndex ].sprite.position.x )
			{
				rightMostIndex = index
			}
		}
		
		remainingTopGround.removeAtIndex( rightMostIndex )
		
		let totalGroundSpaces = remainingTopGround.count / 10
		var numberOfRocks = myController!.diffiCons.rocksPerTenGround * totalGroundSpaces
		var numberOfPlants = myController!.diffiCons.plantsPerTenGround * totalGroundSpaces
		var numberOfFires = myController!.diffiCons.firePlantsPerTenGround * totalGroundSpaces
		
		while( remainingTopGround.count > 0 )
		{
			let randomIndex = Int( arc4random_uniform( UInt32( remainingTopGround.count ) ) )
			let myGround = remainingTopGround[ randomIndex ]
			remainingTopGround.removeAtIndex( randomIndex )
			
			if ( numberOfRocks > 0 )
			{
				let rockObj = RockObj(xStart: myGround.sprite.position.x, yStart: myGround.sprite.position.y )
				rockObj.sprite.position.y += rockObj.sprite.frame.height
				addGameObject( rockObj )
				numberOfRocks -= 1
				continue
			}
			else if ( numberOfPlants > 0 )
			{
				myGround.myPlant = PlantObj(xStart: myGround.sprite.position.x, yStart: myGround.sprite.position.y )
				myGround.myPlant!.sprite.position.y += myGround.myPlant!.sprite.frame.height
				addGameObject( myGround.myPlant! )
				numberOfPlants -= 1
				continue
			}
			else if ( numberOfFires > 0 )
			{
				myGround.myPlant = FirePlant(xStart: myGround.sprite.position.x, yStart: myGround.sprite.position.y )
				myGround.myPlant!.sprite.position.y += myGround.myPlant!.sprite.frame.height - 32
				addGameObject( myGround.myPlant! )
				numberOfFires -= 1
				continue
			}
			else
			{
				break
			}
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
		//should dead plants be counted against score?
		/*
		let plantsLost = objectsDestroyed[ PlantObj( xStart: 0, yStart: 0 ).className() ]
		let firesLost = objectsDestroyed[ FirePlant( xStart: 0, yStart: 0 ).className() ]
		toReturn -= ( plantsLost != nil ? plantsLost! : 0 ) * 5
		toReturn -= ( firesLost != nil ? firesLost! : 0 ) * 10
		*/
		
		return toReturn
	}
	
	/*
	override func pauseAndShowMessage( message : String )
	{
		super.pauseAndShowMessage( message )
		print( "Score: \(getScore())" )
	}
	*/

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