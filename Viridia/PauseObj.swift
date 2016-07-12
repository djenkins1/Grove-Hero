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
	
	var buttons = [UIButton]()
	
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
				//pauseLabels = myScene.pauseAndShowMessage( "Paused" )
				myScene.pauseUpdate = true
				createButtons()
			}
		}
	}
	
	override func updateEvent(scene: GameScene, currentFPS: Int)
	{
		if ( !scene.pauseUpdate )
		{
			var entered = false
			while ( buttons.count > 0 )
			{
				entered = true
				buttons.removeFirst().removeFromSuperview()
			}
			
			if ( entered )
			{
				changeSprite( pauseSprite)
			}
		}
		
	}
	
	private func createButtons()
	{
		if ( myScene == nil )
		{
			return
		}
		
		var yPos = ceil( UIScreen.mainScreen().bounds.height * 0.25 )
		let padding = ceil( UIScreen.mainScreen().bounds.height * 0.04 )
		
		let pauseTitle = ButtonFactory.createCenteredButton( "Paused", buttonType: ButtonType.TitleButton, yCenter: yPos  )
		
		yPos += pauseTitle.frame.height + padding
		let playButton = ButtonFactory.createCenteredButton( "Continue", buttonType: ButtonType.MenuButton, yCenter: yPos )
		
		yPos += playButton.frame.height + padding
		let restButton = ButtonFactory.createCenteredButton( "Restart", buttonType: ButtonType.MenuButton, yCenter: yPos )
		
		yPos += restButton.frame.height + padding
		let quitButton = ButtonFactory.createCenteredButton( "Quit", buttonType: ButtonType.MenuButton, yCenter: yPos )
		
		buttons.append( myScene.addButton( pauseTitle ) )
		buttons.append( myScene.addButton( playButton ) )
		buttons.append( myScene.addButton( restButton ) )
		buttons.append( myScene.addButton( quitButton ) )
		
		playButton.addTarget( self, action: #selector( self.clickPlayButton) , forControlEvents: .TouchUpInside)
		restButton.addTarget( self, action: #selector( self.clickRestartButton) , forControlEvents: .TouchUpInside)
		quitButton.addTarget( self, action: #selector( self.clickQuitButton) , forControlEvents: .TouchUpInside)
	}
	
	@objc func clickPlayButton()
	{
		if ( myScene != nil )
		{
			myScene.pauseUpdate = false
		}
	}
	
	@objc func clickRestartButton()
	{
		if ( myScene != nil )
		{
			myScene.myController.changeState( GameState.Play )
		}
	}
	
	@objc func clickQuitButton()
	{
		if ( myScene != nil )
		{
			myScene.myController.changeState( GameState.Menu )
		}
	}
}