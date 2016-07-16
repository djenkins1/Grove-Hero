//
//  CreditScene.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/1/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit


class CreditScene : GameScene
{
	var myView : SKView!
	
	var creditData : Array<Dictionary<String,String>>! = nil
	
	var allButtons = [UIButton]()
	//function first called when the scene is viewed
	override func didMoveToView(view: SKView)
	{
		myView = view
		if ( myController != nil )
		{
			creditData = myController.readCredits()
		}
		else
		{
			creditData = [Dictionary<String,String>]()
		}
		
		NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.showView), userInfo: nil, repeats: false)
	}
	
	func showView()
	{
		if ( myView != nil )
		{
			createBackground()
			createButtons( myView )
		}
	}
	
	override func willMoveFromView(view: SKView)
	{
		super.willMoveFromView( view )
	}
	
	private func createButtons( view : SKView )
	{
		let screenWidth = UIScreen.mainScreen().bounds.width
		let titleWidth = Int( ceil(screenWidth * 0.5) )
		let paddingWidth = ceil( UIScreen.mainScreen().bounds.width * 0.05 )
		let padding = ceil( UIScreen.mainScreen().bounds.height * 0.04 )
		let centerX = screenWidth / 2
		let startY = CGFloat( ceil( UIScreen.mainScreen().bounds.height * 0.25 ) )
		let defaultWidth : CGFloat = 128
		let defaultHeight : CGFloat  = 32
		let muteX = centerX - CGFloat( titleWidth / 2 ) - CGFloat( defaultWidth / 4 ) - CGFloat( defaultHeight )
		
		let gameTitle = ButtonFactory.createCenteredButton( "Credits", buttonType: .TitleButton, yPos: startY )
		gameTitle.addTarget( self, action: #selector( self.clickBack ) , forControlEvents: .TouchUpInside)
		view.addSubview(gameTitle)
		
		let backButton = ButtonFactory.createButton( "<" , buttonType: .SmallButton, xPos : muteX, yPos : startY )
		backButton.addTarget( self, action: #selector( self.clickBack ) , forControlEvents: .TouchUpInside)
		view.addSubview(backButton)
		
		let buttonsPerRow = floor( screenWidth / ( defaultWidth + paddingWidth ) )
		var index = -1
		for creditRow in creditData
		{
			index = index + 1
			let column = ( index % Int( buttonsPerRow ) )
			let row : CGFloat = CGFloat( index / Int(buttonsPerRow) )
			
			let x = centerBoxPosition( Int(buttonsPerRow), index: column, boxWidth: Int( defaultWidth ) )
			let y = CGFloat( ( row * ( defaultHeight + padding ) )  ) + startY + defaultHeight + padding
			let author = creditRow[ "author"]!
			let title = creditRow[ "title"]!
			
			let button = ButtonFactory.createButton( "\(title) - \(author)", buttonType: .MenuButton, xPos: CGFloat( x ), yPos: y )
			button.titleLabel!.font = button.titleLabel!.font.fontWithSize( 10 )
			button.tag = index
			button.addTarget( self, action: #selector( self.clickCreditsTag(_:)) , forControlEvents: .TouchUpInside)
			view.addSubview(button)
		}
	}
	
	//when a credits button is clicked on in credits view, show the web page link associated with that button
	func clickCreditsTag( sender: AnyObject )
	{
		if let myTag = sender.tag
		{
			if let url = creditData[ myTag ][ "link" ]
			{
				UIApplication.sharedApplication().openURL(NSURL(string: url)!)
			}
		}
	}
	
	func clickBack()
	{
		if ( myController != nil )
		{
			myController.changeState( GameState.Menu )
		}
	}
	
	//returns the position of the box so that it is centered in the view based on its position in the row
	func centerBoxPosition( boxesPerRow: Int, index: Int, boxWidth: Int ) -> Int
	{
		let screenSize: CGRect = UIScreen.mainScreen().bounds
		let screenWidth = Int( floor( screenSize.width * 0.5 ) )
		var toReturn = 0
		let invert = ( boxesPerRow - 1 ) - index
		let dist = invert - ( boxesPerRow / 2 )
		let totalOffset = dist * boxWidth
		if ( boxesPerRow % 2 == 0 )
		{
			toReturn = screenWidth - totalOffset - boxWidth
		}
		else
		{
			toReturn = screenWidth - totalOffset - (boxWidth / 2)
		}
		
		return toReturn
	}
	
	/*
	@objc private func clickPlayButton()
	{
		if ( myController != nil )
		{
			myController.changeState( GameState.Play)
			clearView()
		}
	}
	*/
}