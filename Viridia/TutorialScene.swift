//
//  TutorialScene.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/12/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialScene : GameScene
{
	var specialObj : GameObj!
	
	var beginMessageQueue = [String]()
	
	var endMessageQueue = [String]()
	
	var messageLabel : SKLabelNode!
	
	var subLabel : SKLabelNode!
	
	override func didMoveToView(view: SKView)
	{
		createBackground()
		createLayer( false , atLayer: 1 )
		createLayer( true , atLayer: 2 )
		if ( myController != nil )
		{
			createScene( myController.tutorStage.current() )
			messagesFromState( myController.tutorStage.current() )
			setupMessage()
		}
		else
		{
			print( "Controller nil, could not setup tutorial by stage" )
			createScene( .Done )
		}
		
		//generateScenery()
		//addGameObject( PauseObj() )
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		if ( pauseUpdate && !doneScreen )
		{
			if ( beginMessageQueue.count > 0 )
			{
				changeMessage( beginMessageQueue.removeFirst() )
			}
			else
			{
				changeMessage( "" )
				pauseUpdate = false
			}
			return
		}
		
		if ( doneScreen )
		{
			if ( endMessageQueue.count > 0 )
			{
				changeMessage( endMessageQueue.removeFirst() )
			}
			else
			{
				doneWithLevel()
			}
			return
		}
		
		super.touchesBegan( touches, withEvent: event )
	}
	
	private func doneWithLevel()
	{
		changeMessage( "" )
		if ( myController != nil )
		{
			if ( myController.tutorStage.nextIndex() )
			{
				myController.saveMachine.setTutorialStage( myController.tutorStage.current() )
				myController.changeState( .Tutorial )
			}
			else
			{
				myController.saveMachine.setTutorialStage( .Done )
				myController.diffiCons = EasyDifficulty()
				myController.victoryCond = TimeVictory()
				myController.changeState( .Play )
			}
		}
	}
	
	/*
	func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, rect:CGRect)
	{
		
		// Determine the font scaling factor that should let the label text fit in the given rectangle.
		let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)
		
		// Change the fontSize.
		labelNode.fontSize *= scalingFactor
		
		// Optionally move the SKLabelNode to the center of the rectangle.
		//labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
	}
	*/
	
	//creates the label with the message and sets it to first item in beginMessageQueue
	private func setupMessage()
	{
		let message = ( beginMessageQueue.count > 0 ? beginMessageQueue.removeFirst() : "" )
		messageLabel = addMakeLabel( message, xPos: CGRectGetMidX(self.frame), yPos: CGRectGetMidY(self.frame), fontSize: 32 )
		//adjustLabelFontSizeToFitRect( messageLabel , rect: messageLabel.frame )
		
		subLabel = addMakeLabel( "Tap to Continue", xPos: CGRectGetMidX(self.frame), yPos: CGRectGetMidY(self.frame) - messageLabel.frame.height - 8, fontSize: 28 )
	}
	
	//updates the label text with the next message in the queue and removes it from the queue
	//if no message is left in the queue, then set label text to ""
	private func changeMessage( message : String )
	{
		if ( messageLabel != nil )
		{
			if ( subLabel != nil )
			{
				if ( message != "" )
				{
					subLabel.text = "Tap to Continue"
				}
				else
				{
					subLabel.text = message
				}
			}
			messageLabel.text = message
			//adjustLabelFontSizeToFitRect( messageLabel , rect: messageLabel.frame )
		}
	}
	
	private func messagesFromState( stage : TutorialStage )
	{
		switch( stage )
		{
		case .BombRock:
			beginMessageQueue.removeAll()
			endMessageQueue.removeAll()
			
			beginMessageQueue.append( "Tap and drag the crate over the rock to destroy the crate." )
			
			endMessageQueue.append( "Crates that fall on a rock will damage the rock." )
			endMessageQueue.append( "If a rock gets damaged enough it is destroyed." )
		case .FireBomb:
			beginMessageQueue.removeAll()
			endMessageQueue.removeAll()
			
			beginMessageQueue.append( "Fire plants can shoot flames above them." )
			beginMessageQueue.append( "If they are hit by too many bomb crates they will wither." )
			beginMessageQueue.append( "Tap and drag the crate so that it is above the plant." )
			beginMessageQueue.append( "Then tap on the fire plant to shoot a flame." )
			
			endMessageQueue.append( "Fire plants need to warm up again after they have shot." )
			endMessageQueue.append( "Once they have a red flower they can shoot again." )
		case .HealShrooms:
			beginMessageQueue.removeAll()
			endMessageQueue.removeAll()
			
			beginMessageQueue.append( "Bomb crates that fall onto grass turn it into mycelium." )
			beginMessageQueue.append( "Mycelium turns any plants growing on it into mushrooms." )
			beginMessageQueue.append( "To turn the mycelium back, a health crate can be used." )
			beginMessageQueue.append( "Tap and drag the health crate so it lands on the mycelium." )

			endMessageQueue.append( "Health crates can also heal fire plants that have been damaged." )
		case .RockSpawn:
			beginMessageQueue.removeAll()
			endMessageQueue.removeAll()
			
			beginMessageQueue.append( "Rock crates that fall onto open ground will deposit a rock there." )
			beginMessageQueue.append( "Tap and drag the rock crate to make it fall onto open grass." )
			
			endMessageQueue.append( "If a rock crate falls onto an existing rock, the rock will be fortified." )
			endMessageQueue.append( "Any existing damage done to the rock will be repaired." )
		case .SpiderSpawn:
			beginMessageQueue.removeAll()
			endMessageQueue.removeAll()
			
			beginMessageQueue.append( "If a bomb crate lands on mycelium then it turns into sand." )
			beginMessageQueue.append( "Plants cannot grow on sand, nor can sand be healed." )
			beginMessageQueue.append( "If a bomb crate lands on sand, a sand spider will appear." )
			beginMessageQueue.append( "The sand spider will go after nearby plants." )
			beginMessageQueue.append( "Tap on the sand spider to stop it from eating plants." )
			
			endMessageQueue.append( "Sand spiders will also die from eating a fire plant." )
			endMessageQueue.append( "The fire plant will lose health though." )
		case .Done:
			beginMessageQueue.removeAll()
			endMessageQueue.removeAll()
			
			beginMessageQueue.append( "You have finished your training." )
			beginMessageQueue.append( "You now have the necessary knowledge." )
			
			endMessageQueue.append( "GroveKeeper, go forth and protect!" )
		}
	}
	
	override func didFinishUpdate()
	{
		if ( pauseUpdate )
		{
			return
		}
		
		if ( specialObj != nil && specialObj.isDead )
		{
			doneScreen = true
			pauseUpdate = true
			if ( endMessageQueue.count > 0 )
			{
				changeMessage( endMessageQueue.removeFirst() )
			}
			else
			{
				doneWithLevel()
			}
		}
	}
	
	private func createScene( stage : TutorialStage )
	{
		//utilize a message queue, when past the final message the game unpauses
		switch( stage )
		{
		case .BombRock:
			let topGround = getTopGround()
			if ( topGround.count > 0 )
			{
				let chosenGround = topGround[ topGround.count / 2 ]
				let rockObj = RockObj(xStart: chosenGround.sprite.position.x, yStart: chosenGround.sprite.position.y )
				rockObj.sprite.position.y += rockObj.sprite.frame.height
				addGameObject( rockObj )
				
				let yPos =  UIScreen.mainScreen().bounds.height * 1.5
				specialObj = BombBox(xStart: chosenGround.sprite.position.x - 192, yStart: yPos )
				addGameObject( specialObj )
				pauseUpdate = true
			}
			else
			{
				print( "Missing grounds" )
			}
		case .FireBomb:
			let topGround = getTopGround()
			if ( topGround.count > 0 )
			{
				let chosenGround = topGround[ topGround.count / 2 ]
				chosenGround.myPlant = FirePlant(xStart: chosenGround.sprite.position.x, yStart: chosenGround.sprite.position.y )
				chosenGround.myPlant!.sprite.position.y += chosenGround.myPlant!.sprite.frame.height - 32
				addGameObject( chosenGround.myPlant! )
				
				let yPos =  UIScreen.mainScreen().bounds.height * 1.5
				specialObj = BombBox(xStart: chosenGround.sprite.position.x , yStart: yPos )
				addGameObject( specialObj )
				pauseUpdate = true
			}
			else
			{
				print( "Missing grounds" )
			}
		case .SpiderSpawn:
			let topGround = getTopGround()
			if ( topGround.count > 3 )
			{
				let chosenGround = topGround[ topGround.count / 2 ]
				chosenGround.myPlant = FirePlant(xStart: chosenGround.sprite.position.x, yStart: chosenGround.sprite.position.y )
				chosenGround.myPlant!.sprite.position.y += chosenGround.myPlant!.sprite.frame.height - 32
				addGameObject( chosenGround.myPlant! )
				
				let secondGround = topGround[ 0 ]
				secondGround.damageMe()
				secondGround.damageMe()
				specialObj = secondGround.createSpider()
				
				pauseUpdate = true
			}
			else
			{
				print( "Missing grounds" )
			}
		case .HealShrooms:
			let topGround = getTopGround()
			if ( topGround.count > 0 )
			{
				let chosenGround = topGround[ topGround.count / 2 ]
				chosenGround.myPlant = PlantObj(xStart: chosenGround.sprite.position.x , yStart: chosenGround.sprite.position.y )
				chosenGround.myPlant!.sprite.position.y += chosenGround.myPlant!.sprite.frame.height
				addGameObject( chosenGround.myPlant! )
				chosenGround.damageMe()
				
				let yPos =  UIScreen.mainScreen().bounds.height * 1.5
				specialObj = HealBox(xStart: chosenGround.sprite.position.x - 192 , yStart: yPos )
				addGameObject( specialObj )
				pauseUpdate = true
			}
			else
			{
				print( "Missing grounds" )
			}
		case .RockSpawn:
			let topGround = getTopGround()
			if ( topGround.count > 0 )
			{
				let chosenGround = topGround[ topGround.count / 2 ]
				chosenGround.myPlant = PlantObj(xStart: chosenGround.sprite.position.x, yStart: chosenGround.sprite.position.y )
				chosenGround.myPlant!.sprite.position.y += chosenGround.myPlant!.sprite.frame.height
				addGameObject( chosenGround.myPlant! )
				
				let yPos =  UIScreen.mainScreen().bounds.height * 1.5
				specialObj = RockBox(xStart: chosenGround.sprite.position.x , yStart: yPos )
				addGameObject( specialObj )
				pauseUpdate = true
			}
			else
			{
				print( "Missing grounds" )
			}
		case .Done:
			specialObj = RockBox(xStart: -200 , yStart: -200 )
			addGameObject( specialObj )
			pauseUpdate = true
			return
		}
	}
}

enum TutorialStage : String
{
	case BombRock
	case FireBomb
	case SpiderSpawn
	case HealShrooms
	case RockSpawn
	case Done
	
	static func first() -> TutorialStage
	{
		return BombRock
	}
}

class TutorialStageList
{
	private(set) var currentIndex = 0
	
	private(set) var list = [TutorialStage]()
	
	init( myStage : TutorialStage )
	{
		setupList()
		var index = -1
		for stage in list
		{
			index += 1
			if ( stage == myStage )
			{
				break
			}
		}
		currentIndex = index
	}
	
	private func setupList()
	{
		list.append( .BombRock )
		list.append( .FireBomb )
		list.append( .HealShrooms )
		list.append( .SpiderSpawn )
		list.append( .RockSpawn )
		
		list.append( .Done )
	}
	
	//returns true if has advanced index
	func nextIndex() -> Bool
	{
		if ( currentIndex + 1 >= list.count )
		{
			return false
		}
		
		currentIndex += 1
		return true
	}
	
	func current() -> TutorialStage
	{
		if ( currentIndex < 0 || currentIndex >= list.count )
		{
			return .Done
		}
		
		return list[ currentIndex ]
	}
}