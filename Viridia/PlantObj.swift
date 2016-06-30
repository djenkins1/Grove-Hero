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
	
	static func randomPlantSprite() -> String
	{
		let choices = [ "plant" , "cactus" , "bush" , "plantPurple" ]
		let myChoice = Int( arc4random_uniform( UInt32( choices.count ) ) )
		return "\(choices[myChoice])"
	}
	
	
	static func randomShroomSprite() -> String
	{
		let choices = [ "Brown" , "Red" ]
		let myChoice = Int( arc4random_uniform( UInt32( choices.count ) ) )
		return "mushroom\(choices[myChoice])"
	}
	
	func changeToShroom()
	{
		sprite.texture = SKTexture(imageNamed: PlantObj.randomShroomSprite() )
	}
	
	func changeToPlant()
	{
		sprite.texture = SKTexture( imageNamed: PlantObj.randomPlantSprite() )
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
		}
	}
}