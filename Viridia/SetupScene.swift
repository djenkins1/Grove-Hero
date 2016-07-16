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

	let modes = [ "Box Attack" , "Time Attack" , "Survival" ]
	
	let difficulty = [ "Easy" , "Medium" , "Hard" ]
	
	var diffiButtons = [UIButton]()
	
	var modeButtons = [UIButton]()
	
	//function first called when the scene is viewed
	override func didMoveToView(view: SKView)
	{
		myView = view
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
	
	private func createButtons( view : SKView )
	{
		let screenWidth = UIScreen.mainScreen().bounds.width
		let centerX = screenWidth / 2
		let startY = ceil( UIScreen.mainScreen().bounds.height * 0.1 )
		let defaultHeight : CGFloat = 32
		
		let modeTitle = ButtonFactory.createCenteredButton( "Game Mode", buttonType: .TitleButton, yPos: startY )
		view.addSubview(modeTitle)
		
		let chosenModeIndex = getChosenMode()
		var buttonGroupY = startY + ( defaultHeight * 1.25 )
		modeButtons = createButtonGroup( modes, leftCornerY :  buttonGroupY, chosenIndex: chosenModeIndex )
		for button in modeButtons
		{
			view.addSubview( button )
			button.addTarget( self, action: #selector( self.clickModeButton(_:)) , forControlEvents: .TouchUpInside)
		}
		clickModeButton( modeButtons[ chosenModeIndex ] )
	
		buttonGroupY += defaultHeight * 1.3
		let diffiTitle = ButtonFactory.createCenteredButton( "Difficulty", buttonType: .TitleButton, yPos: buttonGroupY )
		view.addSubview(diffiTitle)
		
		let chosenDiffIndex = getChosenDifficulty()
		buttonGroupY += defaultHeight * 1.25
		diffiButtons = createButtonGroup( difficulty, leftCornerY :  buttonGroupY, chosenIndex: chosenDiffIndex )
		for button in diffiButtons
		{
			view.addSubview( button )
			button.addTarget( self, action: #selector( self.clickDiffiButton(_:)) , forControlEvents: .TouchUpInside)
		}
		clickDiffiButton( diffiButtons[ chosenDiffIndex ] )

		let yesImage = UIImage( named: "greenBoxCheck" ) as UIImage?
		let noImage = UIImage( named: "greenBoxCross" ) as UIImage?
		let yesButton = UIButton(type: UIButtonType.Custom) as UIButton
		let noButton = UIButton(type: UIButtonType.Custom) as UIButton
		
		let newButtonHeight : CGFloat = 48
		let buttonPadding = newButtonHeight * 0.1
		buttonGroupY += defaultHeight * 1.6
		yesButton.frame = CGRectMake( centerX - ( newButtonHeight + buttonPadding ), buttonGroupY, newButtonHeight, newButtonHeight)
		yesButton.setBackgroundImage( yesImage, forState: .Normal )
		yesButton.setTitle( "", forState: .Normal )
		yesButton.layer.zPosition = 20
		view.addSubview( yesButton )
		
		noButton.frame = CGRectMake( centerX + buttonPadding, buttonGroupY, newButtonHeight, newButtonHeight)
		noButton.setBackgroundImage( noImage, forState: .Normal )
		noButton.setTitle( "", forState: .Normal )
		noButton.layer.zPosition = 20
		view.addSubview( noButton )
		
		yesButton.addTarget( self, action: #selector( self.onToGame) , forControlEvents: .TouchUpInside)
		noButton.addTarget( self, action: #selector( self.backToMenu) , forControlEvents: .TouchUpInside)
	}
	
	func backToMenu()
	{
		if ( myController != nil )
		{
			myController.changeState( GameState.Menu )
		}
	}
	
	func onToGame()
	{
		if ( myController != nil )
		{
			myController.changeState( GameState.Play )
			myController.saveMachine.setFavoriteMode( myController.victoryCond  )
			myController.saveMachine.setFavoriteDifficulty( myController.diffiCons )
		}
	}
	
	private func getChosenMode() -> Int
	{
		if ( myController != nil )
		{
			let favMode = myController.saveMachine.getFavoriteMode()
			if ( favMode is TimeVictory )
			{
				return 1
			}
			else if ( favMode is BoxVictory )
			{
				return 0
			}
		}

		return 0

	}
	
	private func getChosenDifficulty() -> Int
	{
		if ( myController != nil )
		{
			let favDiffi = myController.saveMachine.getFavoriteDifficulty()
			if ( favDiffi is EasyDifficulty )
			{
				return 0
			}
			else if ( favDiffi is MidDifficulty )
			{
				return 1
			}
			else if ( favDiffi is HardDifficulty )
			{
				return 2
			}
		}
		
		return 0
	}
	
	func clickModeButton( sender: AnyObject )
	{
		for button in modeButtons
		{
			toggleButton( false , button: button )
		}
		
		if ( sender is UIButton && myController != nil )
		{
			toggleButton( true, button: ( sender as! UIButton ) )
			let title : String = ( sender as! UIButton ).currentTitle!
			switch( title )
			{
			case "Box Attack":
				myController.victoryCond = BoxVictory()
			case "Time Attack":
				myController.victoryCond = TimeVictory()
			case "Survival":
				print( "TODO: Survival" )
			default:
				print( "Mode not valid: \(title)" )
			}
		}
	}
	
	func clickDiffiButton( sender : AnyObject )
	{
		for button in diffiButtons
		{
			toggleButton( false , button: button )
		}
		
		if ( sender is UIButton && myController != nil )
		{
			toggleButton( true, button: ( sender as! UIButton ) )
			let title : String = ( sender as! UIButton ).currentTitle!
			switch( title )
			{
			case "Easy":
				myController.diffiCons = EasyDifficulty()
			case "Medium":
				myController.diffiCons = MidDifficulty()
			case "Hard":
				myController.diffiCons = HardDifficulty()
			default:
				print( "Difficulty not valid: \(title)" )
			}
		}
	}
	
	private func createButtonGroup( titles : Array<String>, leftCornerY : CGFloat, chosenIndex : Int = 0 ) -> [UIButton]
	{
		var toReturn = [UIButton]()
		if ( titles.count > 3 )
		{
			print( "Too many buttons in group" )
			return toReturn
		}
		
		let screenWidth = UIScreen.mainScreen().bounds.width
		let padding = ceil( UIScreen.mainScreen().bounds.height * 0.04 )
		let centerX = screenWidth / 2
		let defaultWidth : CGFloat = 128
		let defaultHeight : CGFloat = 32
		
		var index = -1
		for title in titles
		{
			index += 1
			let button = UIButton(type: UIButtonType.Custom) as UIButton
			button.setTitle( title , forState: .Normal )
			
			toggleButton( index == chosenIndex, button: button )
			
			if ( index == titles.count / 2 )
			{
				button.frame = CGRectMake( centerX - ( defaultWidth / 2 ), leftCornerY, defaultWidth , defaultHeight )
			}
			else if ( index < titles.count / 2 )
			{
				button.frame = CGRectMake(  centerX - ( defaultWidth / 2 ) - defaultWidth - padding , leftCornerY, defaultWidth , defaultHeight)
			}
			else
			{
				button.frame = CGRectMake( centerX + ( defaultWidth / 2 ) + padding, leftCornerY, defaultWidth,defaultHeight )
			}
			
			toReturn.append( button )
		}
		return toReturn
	}
	
	private func toggleButton( isChosen : Bool, button : UIButton )
	{
		let backImage = UIImage( named: "buttonGreenDef" ) as UIImage?
		let chosenImage = UIImage( named: "buttonGreenHit" ) as UIImage?
		if ( isChosen )
		{
			button.setBackgroundImage( chosenImage, forState: .Normal )
			button.setTitleColor( UIColor.whiteColor(), forState: .Normal)
		}
		else
		{
			button.setBackgroundImage( backImage, forState: .Normal )
			button.setTitleColor( UIColor.blackColor(), forState: .Normal)
		}
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