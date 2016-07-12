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
	static func createButton( buttonTitle : String, buttonType : ButtonType , xCenter : CGFloat, yCenter : CGFloat ) -> UIButton
	{
		let defaultWidth : CGFloat = 128
		let defaultHeight : CGFloat  = 32
		let button = UIButton(type: UIButtonType.Custom) as UIButton
		
		switch( buttonType )
		{
		case .TitleButton:
			let screenWidth = UIScreen.mainScreen().bounds.width
			let titleWidth = ceil(screenWidth * 0.5)
			let titleImage = UIImage( named: "buttonTitle" ) as UIImage?
			button.frame = CGRectMake( xCenter - ( titleWidth / 2 ), yCenter - ( defaultHeight / 2), titleWidth, defaultHeight )
			button.setBackgroundImage( titleImage, forState: .Normal )
			button.userInteractionEnabled = false
		case .MenuButton:
			let backImage = UIImage( named: "buttonGreenDef" ) as UIImage?
			button.frame = CGRectMake( xCenter - ( defaultWidth / 2 ), yCenter - ( defaultHeight / 2), defaultWidth, defaultHeight )
			button.setBackgroundImage( backImage, forState: .Normal )
		case .SmallButton:
			let smallImage = UIImage( named: "buttonSmall" ) as UIImage?
			button.frame = CGRectMake( xCenter - ( defaultHeight / 2 ),  yCenter - ( defaultHeight / 2 ),  defaultHeight, defaultHeight )
			button.setBackgroundImage( smallImage, forState: .Normal )
		}

		button.setTitleColor( UIColor.blackColor(), forState: .Normal)
		button.setTitle( buttonTitle, forState: .Normal )
		button.layer.zPosition = 100

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
}

enum ButtonType
{
	case TitleButton
	case MenuButton
	case SmallButton
}