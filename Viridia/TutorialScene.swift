//
//  TutorialScene.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/12/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

//		::shows a message on the screen based on stage
//		::tapping on the screen goes to next message, or if no next message then it unpauses the game
//		::has an end condition based on stage
//		::has a room setup based on stage

//	TODO: need to have instance of TutorialStageList in viewController and use that instead for getting current stage
class TutorialScene : GameScene
{
	//holds a special object that the tutorial stage wants to know about, i.e whether it is dead...
	var specialObj : GameObj!
	
	override func didMoveToView(view: SKView)
	{
		createBackground()
		createLayer( false , atLayer: 1 )
		createLayer( true , atLayer: 2 )
		if ( myController != nil )
		{
			createScene( myController.tutorStage )
		}
		else
		{
			print( "Controller nil, could not setup tutorial by stage" )
			createScene( .Done )
		}
		
		//generateScenery()
		//addGameObject( PauseObj() )
	}
	
	private func createScene( stage : TutorialStage )
	{
		//utilize a message queue, when past the final message the game unpauses
		switch( stage )
		{
		case .BombRock:
			//create a single rock
			//create a bomb box anywhere but directly above the rock
			//message:		
			//			tap and drag crate over rock to destroy the crate
			//after:
			//			crates that fall on rocks will also damage the rock
			//			if too many crates fall on a rock, the rock is destroyed
			//end:	when bomb box is destroyed
			return
		case .FireBomb:
			//create a fire plant
			//create a bomb box directly above the fire plant
			//message:		
			//			fire plants are special plants that can shoot flames above them
			//			if they are hit by too many bomb crates they will die off
			//			tap and drag a crate so that it is above the fire plant
			//			then tap on the fire plant to shoot a fireball
			//			the fireball will destroy any crate it hits
			//after:
			//			fire plants need to warm up again after they shoot flames
			//			once they have a red flower they have another fireball ready
			//end:	when bomb box is destroyed
			return
		case .SpiderSpawn:
			//spawn plants
			//turn grass into mycelium into sand
			//simulate sand being hit by bomb box
			//message:
			//			if a bomb crate lands on mycelium, the mycelium turns into sand
			//			this  means that no plants will grow on it and it cannot be healed by a health box
			//			if a bomb crates lands on sand, a sand spider will appear
			//			the sand spider will go after any nearby plants and eat them
			//			tap on the sand spider to kill it before it can eat the plants
			//after:
			//			sand spiders can also die from eating a fire plant
			//			the fire plant will lose health but its hot exterior kills off the spider
			//end:	when spider is finally dead
			return
		case .HealShrooms:
			//create a heal box
			//create plants
			//simulate a bomb box hitting grassy plants
			//message:	
			//			when a bomb crate falls onto grass, the grass turns into mycelium
			//			mycelium turns any plants above it into mushrooms
			//			To heal the grass, a health crate can be used
			//			Tap and drag the health crate so it lands on the mycelium
			//after:
			//			health boxes can also heal fire plants that have been damaged by bomb crates
			//end:	when heal box is destroyed
			return
		case .RockSpawn:
			//create a rock box
			//message:	
			//			when a rock crate falls onto ground, a new rock will jut up from the ground
			//			tap and drag on the rock crate to make it fall onto open grass
			//after:	
			//			if a rock crates falls onto an existing rock, the rock will be fortified
			//			any existing damage done to the rock will be healed
			//end:	when rock box is destroyed
			return
		case .Done:
			//nothing is created, just have an empty field
			//message:
			//		you have finished your training
			//		you now have the necesary knowledge
			//		GroveKeeper, go forth and protect
			//
			//when the final message is tapped away, setup difficulty/victory to easy/timed and transition to LevelScene
			return
		}
	}
}

enum TutorialStage
{
	case BombRock
	case FireBomb
	case SpiderSpawn
	case HealShrooms
	case RockSpawn
	case Done
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
	
	func nextIndex()
	{
		if ( currentIndex + 1 >= list.count )
		{
			return
		}
		
		currentIndex += 1
	}
}