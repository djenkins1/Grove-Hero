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
	var myView : SKView!
	
	var allButtons = [UIButton]()
	//function first called when the scene is viewed
	override func didMoveToView(view: SKView)
	{
		myView = view
		createBackground()
		createButtons( view )
		setupGenerators()
	}
	
	override func willMoveFromView(view: SKView)
	{
		super.willMoveFromView( view )
	}
	
	private func createButtons( view : SKView )
	{
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
		
	}
	
	//returns the corresponding unicode character for the mute state provided
	func getMuteIconText( isMuted : Bool ) -> String
	{
		if ( isMuted )
		{
			return "\u{1f507}"
		}
		else
		{
			return "\u{1F50A}"
		}
	}
	
	func clickMuteButton( sender: AnyObject )
	{
		if ( myController != nil )
		{
			let currentMuteStatus = myController.isMuted
			(sender as! UIButton).setTitle( getMuteIconText( !currentMuteStatus ), forState: .Normal )
			myController.setMuted(  !currentMuteStatus )
		}
	}
	
	func clickPlayButton()
	{
		if ( myController != nil )
		{
			myController.changeState( GameState.Play)
		}
	}
	
	func clickCreditButton()
	{
		if ( myController != nil )
		{
			myController.changeState( GameState.Credits )
		}
	}
	
	//adds all the generators
	func setupGenerators()
	{
		//generatorList.append( BoxGenerator( screenWidth: self.frame.width, screenHeight: self.frame.height ).createEvent(self) )
		generatorList.append( CloudGenerator( screenWidth: self.frame.width, screenHeight: self.frame.height ).createEvent(self) )
	}
}