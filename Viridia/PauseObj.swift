//
//  PauseObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/6/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class PauseObj : GameObj
{
	let pauseSprite = "pauseBlack"
	
	let unpauseSprite = "pauseWhite"
	
	var pauseLabels = [SKLabelNode]()
	
	init()
	{
		super.init(spriteName: pauseSprite, xStart: 0, yStart: 0 )
		sprite.zPosition = 105
		sprite.xScale = 1.5
		sprite.yScale = 1.5
	}
	
	override func createEvent(scene: GameScene) -> GameObj
	{
		super.createEvent( scene )
		let paddingWidth = scene.frame.width * 0.01
		let paddingHeight = scene.frame.height * 0.15
		jumpTo( scene.frame.width - sprite.frame.width - paddingWidth , y: scene.frame.height - sprite.frame.height - paddingHeight )
		return self
		
	}
	
	override func hasCollideEffect(other: GameObj) -> Bool
	{
		return false
	}
	
	//fires when the object is touched
	override func touchEvent( location : CGPoint )
	{
		if ( myScene != nil && !myScene.doneScreen )
		{
			if ( !myScene.pauseUpdate )
			{
				changeSprite( unpauseSprite )
				pauseLabels = myScene.pauseAndShowMessage( "Paused" )
			}
		}
	}
	
	override func updateEvent(scene: GameScene, currentFPS: Int)
	{
		if ( !scene.pauseUpdate && pauseLabels.count > 0 )
		{
			while pauseLabels.count > 0
			{
				pauseLabels.removeFirst().removeFromParent()
			}
			changeSprite( pauseSprite)
		}
		
	}
}