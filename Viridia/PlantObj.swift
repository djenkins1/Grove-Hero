//
//  PlantObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/19/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class PlantObj : GameObj
{
	var lives : Int = 1
	
	var isShroom = false
	
	init( xStart: CGFloat, yStart: CGFloat)
	{
		let spriteName = PlantObj.randomPlantSprite()
		super.init( spriteName: spriteName, xStart: xStart, yStart: yStart )
		initOther()
	}
	
	override init( spriteName : String, xStart: CGFloat, yStart: CGFloat )
	{
		super.init( spriteName: spriteName, xStart: xStart, yStart: yStart )
		initOther()
	}
	
	private func initOther()
	{
		self.dieOnCollide = false
		self.dieOutsideScreen = true
		self.sprite.zPosition = 20
	}
	
	static func getMaxLives() -> Int
	{
		return 1
	}
	
	static func randomPlantSprite() -> String
	{
		let choices : [PlantSpriteStr] = [ .plant , .cactus , .bush , .plantPurple ]
		let myChoice = Int( arc4random_uniform( UInt32( choices.count ) ) )
		return "\(choices[myChoice].rawValue)"
	}
	
	
	static func randomShroomSprite() -> String
	{
		let choices : [PlantSpriteStr] = [ .mushroomBrown , .mushroomRed ]
		let myChoice = Int( arc4random_uniform( UInt32( choices.count ) ) )
		return "\(choices[myChoice].rawValue)"
	}
	
	func changeToShroom()
	{
		changeSprite( PlantObj.randomShroomSprite() )
		isShroom = true
	}
	
	func changeToPlant()
	{
		changeSprite( PlantObj.randomPlantSprite() )
		isShroom = false
	}
	
	override func hasCollideEffect(other: GameObj) -> Bool
	{
		return false
	}
	
	func damage()
	{
		lives = lives - 1
		if ( lives <= 0 )
		{
			makeDead()
			if ( myScene != nil )
			{
				if ( self is FirePlant )
				{
					myScene.playSoundEffect( Sounds.firePlantHit )
				}
				else
				{
					myScene.playSoundEffect( Sounds.deadShroom )
				}
			}
		}
	}
	
	func convertToFossil() -> RockObj?
	{
		deathModeEvent( 2 )
		if let mySpriteName = mySprites.getCurrentImageString()
		{
			if let myPlant = PlantSpriteStr( rawValue : mySpriteName  )
			{
				return FossilRock( spriteName: PlantSpriteStr.fossilFromPlant( myPlant ), xStart: self.sprite.position.x, yStart: self.sprite.position.y )
			}
			else
			{
				print( "My plant is null when converting to fossil" )
			}
		}
		else
		{
			print( "Current sprite name is null when converting to fossil" )
		}
		
		return nil
	}
}

enum PlantSpriteStr : String
{
	case mushroomBrown
	case mushroomRed
	case plant
	case cactus
	case bush
	case plantPurple
	
	static func fossilFromPlant( myPlant : PlantSpriteStr ) -> String
	{
		switch( myPlant )
		{
		case .bush:
			return "fossilBush"
		case .plant:
			return "fossilPlant"
		case .plantPurple:
			return "fossilPurple"
		case .cactus:
			return "fossilCactus"
		case .mushroomRed:
			return "fossilShroomRed"
		case .mushroomBrown:
			return "fossilShroomBrown"
		}
	}
}