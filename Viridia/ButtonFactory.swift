//
//  ButtonFactory.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/11/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonFactory
{
	static let defaultWidth : CGFloat = 128
	
	static let defaultHeight : CGFloat = 32
	
	static func createButton( buttonTitle : String, buttonType : ButtonType , xCenter : CGFloat, yCenter : CGFloat ) -> UIButton
	{
		switch( buttonType )
		{
		case .TitleButton:
			let screenWidth = UIScreen.mainScreen().bounds.width
			let titleWidth = ceil(screenWidth * 0.5)
			return createButton( buttonTitle, buttonType : buttonType, xPos : xCenter - ( titleWidth / 2 ), yPos : yCenter - ( defaultHeight / 2) )
		case .MenuButton:
			return createButton( buttonTitle, buttonType : buttonType, xPos : xCenter - ( defaultWidth / 2 ), yPos : yCenter - ( defaultHeight / 2) )
		case .SmallButton:
			return createButton( buttonTitle, buttonType : buttonType, xPos : xCenter - ( defaultHeight / 2 ), yPos : yCenter - ( defaultHeight / 2) )
		}
	}
	
	static func createButton( buttonTitle : String, buttonType : ButtonType , xCenter : CGFloat, yPos : CGFloat ) -> UIButton
	{
		switch( buttonType )
		{
		case .TitleButton:
			let screenWidth = UIScreen.mainScreen().bounds.width
			let titleWidth = ceil(screenWidth * 0.5)
			return createButton( buttonTitle, buttonType : buttonType, xPos : xCenter - ( titleWidth / 2 ), yPos : yPos )
		case .MenuButton:
			return createButton( buttonTitle, buttonType : buttonType, xPos : xCenter - ( defaultWidth / 2 ), yPos : yPos )
		case .SmallButton:
			return createButton( buttonTitle, buttonType : buttonType, xPos : xCenter - ( defaultHeight / 2 ), yPos : yPos )
		}
	}

	static func createButton( buttonTitle : String, buttonType : ButtonType, xPos : CGFloat, yPos : CGFloat ) -> UIButton
	{
		let button = UIButton(type: UIButtonType.Custom) as UIButton
		
		switch( buttonType )
		{
		case .TitleButton:
			let screenWidth = UIScreen.mainScreen().bounds.width
			let titleWidth = ceil(screenWidth * 0.5)
			let titleImage = UIImage( named: "buttonTitle" ) as UIImage?
			button.frame = CGRectMake( xPos, yPos , titleWidth, defaultHeight )
			button.setBackgroundImage( titleImage, forState: .Normal )
			button.userInteractionEnabled = false
		case .MenuButton:
			let backImage = UIImage( named: "buttonGreenDef" ) as UIImage?
			button.frame = CGRectMake( xPos, yPos, defaultWidth, defaultHeight )
			button.setBackgroundImage( backImage, forState: .Normal )
		case .SmallButton:
			let smallImage = UIImage( named: "buttonSmall" ) as UIImage?
			button.frame = CGRectMake( xPos, yPos,  defaultHeight, defaultHeight )
			button.setBackgroundImage( smallImage, forState: .Normal )
		}
		
		button.setTitleColor( UIColor.blackColor(), forState: .Normal)
		button.setTitle( buttonTitle, forState: .Normal )
		button.layer.zPosition = 100
		setupDefaultFont( button )
		return button
	}
	
	static func createCenteredButton( buttonTitle : String, buttonType: ButtonType, yCenter : CGFloat ) -> UIButton
	{
		let screenWidth = UIScreen.mainScreen().bounds.width
		return createButton( buttonTitle, buttonType: buttonType, xCenter : screenWidth / 2, yCenter : yCenter )
	}
	
	static func createCenteredButton( buttonTitle : String, buttonType : ButtonType, xOffset : CGFloat, yCenter : CGFloat ) -> UIButton
	{
		let screenWidth = UIScreen.mainScreen().bounds.width
		return createButton( buttonTitle, buttonType: buttonType, xCenter : ( screenWidth / 2 ) - xOffset, yCenter : yCenter )
	}
	
	static func createCenteredButton( buttonTitle : String, buttonType : ButtonType, yPos : CGFloat ) -> UIButton
	{
		let screenWidth = UIScreen.mainScreen().bounds.width
		return createButton( buttonTitle, buttonType: buttonType, xCenter : screenWidth / 2, yPos : yPos )
	}
	
	static func setupDefaultFont( button : UIButton )
	{
		button.titleLabel!.font = UIFont( name: "Thonburi", size: button.titleLabel!.font!.pointSize )
	}
	
	static func disableButton( button : UIButton )
	{
		button.userInteractionEnabled = false
		let image = UIImage( named: "disabledButton" ) as UIImage?
		button.setBackgroundImage( image, forState: .Normal )
		button.setTitleColor( UIColor.grayColor(), forState: .Normal)
	}
}

enum ButtonType
{
	case TitleButton
	case MenuButton
	case SmallButton
}