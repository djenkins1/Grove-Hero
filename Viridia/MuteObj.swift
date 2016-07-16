//
//  MuteObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/15/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class MuteObj : GameObj
{
	let muteSprite = "musicOff"
	
	let unmuteSprite = "musicOn"
	
	init()
	{
		super.init(spriteName: unmuteSprite, xStart: 0, yStart: 0 )
		sprite.zPosition = 105
		sprite.xScale = 2.0
		sprite.yScale = 2.0
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
		if ( myScene != nil && myScene.myController != nil )
		{
			let currentMuteStatus = myScene.myController.isMuted
			changeSprite( ( currentMuteStatus ? unmuteSprite : muteSprite ) )
			myScene.myController.setMuted( !currentMuteStatus )
		}
	}
}