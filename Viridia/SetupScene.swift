//
//  SetupScene.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/8/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class SetupScene : GameScene
{
	var myView : SKView!

	//function first called when the scene is viewed
	override func didMoveToView(view: SKView)
	{
		myView = view
		createBackground()
		createButtons( view )
	}
	
	private func createButtons( view : SKView )
	{
		//big title box labeled: Setup Game
		//title box labeled: Game Mode
		//	underneath:
		//		three mode settings(mutually exclusvie): Timed,Box,Survival
		//	maybe also: Dialog box that explains the game mode
		//title box labeled: Difficulty
		//	underneath:
		//		three difficulty settings(mutually exclusive): easy,medium,hard
		//ok button that goes to play level
		//	have seperate background: greenBoxCheck
		//back button that goes back to menu
		//	have seperate background: greenBoxCross
		
		
		/*
		let titleImage = UIImage( named: "buttonTitle" ) as UIImage?
		let backImage = UIImage( named: "buttonGreenDef" ) as UIImage?
		let smallImage = UIImage( named: "buttonSmall" ) as UIImage?
		let gameTitle = UIButton(type: UIButtonType.Custom) as UIButton
		let playButton = UIButton(type: UIButtonType.Custom) as UIButton
		let credButton = UIButton(type: UIButtonType.Custom) as UIButton
		let muteButton = UIButton(type: UIButtonType.Custom) as UIButton
		
		let screenWidth = UIScreen.mainScreen().bounds.width
		let titleWidth = Int( ceil(screenWidth * 0.5) )
		let padding = Int( ceil( UIScreen.mainScreen().bounds.height * 0.04 ) )
		let centerX = screenWidth / 2
		let startY = Int( ceil( UIScreen.mainScreen().bounds.height * 0.25 ) )
		let defaultWidth = 128
		let defaultHeight = 32
		let muteX = centerX - CGFloat( titleWidth / 2 ) - CGFloat( defaultWidth / 4 ) - CGFloat( defaultHeight )
		gameTitle.frame = CGRectMake( CGFloat( centerX - CGFloat( titleWidth / 2 ) ), CGFloat( startY ), CGFloat( titleWidth ), CGFloat(defaultHeight ))
		muteButton.frame = CGRectMake( muteX, CGFloat( startY ), CGFloat( defaultHeight ), CGFloat(defaultHeight ))
		playButton.frame = CGRectMake( CGFloat( centerX - CGFloat( defaultWidth / 2 ) ), CGFloat( startY + padding + defaultHeight ), CGFloat( defaultWidth ), CGFloat(defaultHeight ))
		credButton.frame = CGRectMake( CGFloat( centerX - CGFloat( defaultWidth / 2 ) ), CGFloat( startY + (2 * ( padding  + defaultHeight ) ) ), CGFloat( defaultWidth ), CGFloat(defaultHeight ))
		
		gameTitle.setBackgroundImage( titleImage, forState: .Normal )
		playButton.setBackgroundImage( backImage, forState: .Normal )
		credButton.setBackgroundImage( backImage, forState: .Normal )
		muteButton.setBackgroundImage( smallImage, forState: .Normal )
		
		gameTitle.setTitleColor( UIColor.blackColor(), forState: .Normal)
		playButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		credButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		muteButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		
		gameTitle.setTitle( "Grovekeeper", forState: .Normal )
		gameTitle.userInteractionEnabled = false
		playButton.setTitle( "Play", forState: .Normal )
		credButton.setTitle( "Credits", forState: .Normal )
		var currentMuteStatus = false
		if ( myController != nil )
		{
			currentMuteStatus = myController.isMuted
		}
		
		muteButton.setTitle( getMuteIconText( currentMuteStatus ), forState: .Normal )
		
		playButton.layer.zPosition = 20
		credButton.layer.zPosition = 20
		gameTitle.layer.zPosition = 20
		muteButton.layer.zPosition = 20
		
		view.addSubview(gameTitle)
		view.addSubview(playButton)
		view.addSubview(credButton)
		view.addSubview(muteButton)
		
		playButton.addTarget( self, action: #selector( self.clickPlayButton) , forControlEvents: .TouchUpInside)
		credButton.addTarget( self, action: #selector( self.clickCreditButton) , forControlEvents: .TouchUpInside)
		muteButton.addTarget( self, action: #selector( self.clickMuteButton(_:)) , forControlEvents: .TouchUpInside)
		*/
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		return
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		return
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		return
	}
}