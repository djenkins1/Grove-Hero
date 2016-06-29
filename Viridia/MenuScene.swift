//
//  MenuScene.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/26/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene : GameScene
{
	var allButtons = [UIButton]()
	//function first called when the scene is viewed
	override func didMoveToView(view: SKView)
	{
		createBackground()
		createButtons( view )
	}
	
	/* Called when a touch begins */
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
	{

	}
	
	private func clearView()
	{
		
	}
	
	override func willMoveFromView(view: SKView)
	{
		super.willMoveFromView( view )
		for sub in view.subviews
		{
			sub.removeFromSuperview()
		}
	}
	
	private func createButtons( view : SKView )
	{
		let titleImage = UIImage( named: "buttonTitle" ) as UIImage?
		let backImage = UIImage( named: "buttonGreenDef" ) as UIImage?
		let gameTitle = UIButton(type: UIButtonType.Custom) as UIButton
		let playButton = UIButton(type: UIButtonType.Custom) as UIButton
		let credButton = UIButton(type: UIButtonType.Custom) as UIButton
		
		let screenWidth = UIScreen.mainScreen().bounds.width
		let titleWidth = Int( ceil(screenWidth * 0.5) )
		let padding = Int( ceil( UIScreen.mainScreen().bounds.height * 0.04 ) )
		let centerX = screenWidth / 2
		let startY = Int( ceil( UIScreen.mainScreen().bounds.height * 0.25 ) )
		let defaultWidth = 128
		let defaultHeight = 32
		gameTitle.frame = CGRectMake( CGFloat( centerX - CGFloat( titleWidth / 2 ) ), CGFloat( startY ), CGFloat( titleWidth ), CGFloat(defaultHeight ))
		playButton.frame = CGRectMake( CGFloat( centerX - CGFloat( defaultWidth / 2 ) ), CGFloat( startY + padding + defaultHeight ), CGFloat( defaultWidth ), CGFloat(defaultHeight ))
		credButton.frame = CGRectMake( CGFloat( centerX - CGFloat( defaultWidth / 2 ) ), CGFloat( startY + (2 * ( padding  + defaultHeight ) ) ), CGFloat( defaultWidth ), CGFloat(defaultHeight ))

		gameTitle.setBackgroundImage( titleImage, forState: .Normal )
		playButton.setBackgroundImage( backImage, forState: .Normal )
		credButton.setBackgroundImage( backImage, forState: .Normal )
		
		gameTitle.setTitleColor( UIColor.blackColor(), forState: .Normal)
		playButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		credButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		
		gameTitle.setTitle( "Game Title", forState: .Normal )
		gameTitle.userInteractionEnabled = false
		playButton.setTitle( "Play", forState: .Normal )
		credButton.setTitle( "Credits", forState: .Normal )
		
		view.addSubview(gameTitle)
		view.addSubview(playButton)
		view.addSubview(credButton)
		
		playButton.addTarget( self, action: #selector( self.clickPlayButton) , forControlEvents: .TouchUpInside)
	}
	
	@objc private func clickPlayButton()
	{
		if ( myController != nil )
		{
			myController.changeState( GameState.Play)
		}
	}
}