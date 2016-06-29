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
	override func didMoveToView(view: SKView)
	{
		createBackground()
		setupGenerators()
		createLayer( false , atLayer: 1 )
		createLayer( true , atLayer: 2 )
		generateScenery()
		shouldCheckLose = true
	}
	
	func generateScenery()
	{
		var numberOfRocks = 2
		var numberOfPlants = 5//TODO :Should be based off number of ground that are isTop
		var numberOfFires = 2
		let allGround = allObjectsOfType( GroundObj )
		var remainingTopGround = [GroundObj]()
		for obj in allGround
		{
			if ( obj is GroundObj && ( obj as! GroundObj).isTop )
			{
				remainingTopGround.append( (obj as! GroundObj) )
			}
		}
		
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

}