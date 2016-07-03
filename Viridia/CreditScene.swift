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
		
		createBackground()
		createButtons( view )
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
		let backButton = UIButton(type: UIButtonType.Custom) as UIButton
		
		let screenWidth = UIScreen.mainScreen().bounds.width
		let titleWidth = Int( ceil(screenWidth * 0.5) )
		let paddingWidth = ceil( UIScreen.mainScreen().bounds.width * 0.05 )
		let padding = ceil( UIScreen.mainScreen().bounds.height * 0.04 )
		let centerX = screenWidth / 2
		let startY = CGFloat( ceil( UIScreen.mainScreen().bounds.height * 0.25 ) )
		let defaultWidth : CGFloat = 128
		let defaultHeight : CGFloat  = 32
		let muteX = centerX - CGFloat( titleWidth / 2 ) - CGFloat( defaultWidth / 4 ) - CGFloat( defaultHeight )
		
		let buttonsPerRow = floor( screenWidth / ( defaultWidth + paddingWidth ) )
		/*
		playButton.frame = CGRectMake( CGFloat( centerX - CGFloat( defaultWidth / 2 ) ), CGFloat( startY + padding + defaultHeight ), CGFloat( defaultWidth ), CGFloat(defaultHeight ))
		credButton.frame = CGRectMake( CGFloat( centerX - CGFloat( defaultWidth / 2 ) ), CGFloat( startY + (2 * ( padding  + defaultHeight ) ) ), CGFloat( defaultWidth ), CGFloat(defaultHeight ))
		*/
		gameTitle.frame = CGRectMake( CGFloat( centerX - CGFloat( titleWidth / 2 ) ), CGFloat( startY ), CGFloat( titleWidth ), CGFloat(defaultHeight ))
		gameTitle.setBackgroundImage( titleImage, forState: .Normal )
		gameTitle.setTitleColor( UIColor.blackColor(), forState: .Normal)
		gameTitle.setTitle( "Credits", forState: .Normal )
		gameTitle.addTarget( self, action: #selector( self.clickBack ) , forControlEvents: .TouchUpInside)
		view.addSubview(gameTitle)
		
		backButton.frame = CGRectMake( muteX, CGFloat( startY ), CGFloat( defaultHeight ), CGFloat(defaultHeight ))
		backButton.setBackgroundImage( smallImage, forState: .Normal )
		backButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		backButton.setTitle( "<", forState: .Normal )
		backButton.addTarget( self, action: #selector( self.clickBack ) , forControlEvents: .TouchUpInside)
		view.addSubview(backButton)
		
		var index = -1
		for creditRow in creditData
		{
			index = index + 1
			let button = UIButton(type: UIButtonType.Custom) as UIButton
			let column = ( index % Int( buttonsPerRow ) )
			let row : CGFloat = CGFloat( index / Int(buttonsPerRow) )
			
			let x = centerBoxPosition( Int(buttonsPerRow), index: column, boxWidth: Int( defaultWidth ) )
			let y = CGFloat( ( row * ( defaultHeight + padding ) )  ) + startY + defaultHeight + padding
			button.frame = CGRectMake( CGFloat( x ), CGFloat( y ), defaultWidth, defaultHeight )
			button.setBackgroundImage( backImage, forState: .Normal )
			button.setTitleColor( UIColor.blackColor(), forState: .Normal)
			
			let author = creditRow[ "author"]!
			let title = creditRow[ "title"]!
			button.setTitle( "\(title) - \(author)" , forState: .Normal )
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