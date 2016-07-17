//
//  SpriteRoll.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/1/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class SpriteRoll
{
	private(set) var secondsPerImage : CGFloat = 0
	
	private var images = [String]()
	
	private var imageIndex : Int = 0
	
	private var stepCounter = 0
	
	func withImages( newImages : Array<String> ) -> SpriteRoll
	{
		self.images = newImages
		imageIndex = 0
		stepCounter = 0
		return self
	}
	
	func appendImage( newImage : String ) -> SpriteRoll
	{
		self.images.append( newImage )
		return self
	}
	
	func prependImage( newImage : String ) -> SpriteRoll
	{
		self.images.insert( newImage , atIndex: 0 )
		return self
	}
	
	func setImageIndex( newIndex : Int ) -> Bool
	{
		if ( newIndex < 0 || newIndex >= images.count )
		{
			return false
		}
		
		if ( newIndex == imageIndex )
		{
			return false
		}
		
		imageIndex = newIndex
		return true
	}
	
	func syncImageOfObj( obj : GameObj )
	{
		let image = getCurrentImageString()
		if image != nil
		{
			obj.setSprite( image! )
		}
	}
	
	//changes the secondsPerImage to the value provided and returns self for chaining
	func withImageSpeed( newSpeed : CGFloat ) -> SpriteRoll
	{
		secondsPerImage = newSpeed
		return self
	}
	
	func getCurrentImageString() -> String?
	{
		if ( imageIndex < 0 || imageIndex >= images.count )
		{
			return nil
		}
		
		return images[ imageIndex ]
	}
	
	//returns true if the currentImage changed or false otherwise
	func animate( currentFPS : Int ) -> Bool
	{
		if ( secondsPerImage == 0 || images.count == 0 || images.count == 1 )
		{
			return false
		}
		
		var toReturn = false
		stepCounter += 1
		let stepsNeeded = Int( ceil( CGFloat( currentFPS ) * abs( secondsPerImage ) ) )
		if ( stepCounter >= stepsNeeded )
		{
			stepCounter = 0
			toReturn = true
			
			imageIndex += ( secondsPerImage > 0 ? 1 : -1 )
			if ( imageIndex >= images.count )
			{
				imageIndex = 0
			}
			
			if ( imageIndex < 0 )
			{
				imageIndex = images.count - 1
			}
		}
		
		return toReturn
	}
}