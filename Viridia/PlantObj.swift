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
	init( xStart: CGFloat, yStart: CGFloat)
	{
		let spriteName = PlantObj.randomPlantSprite()
		super.init( spriteName: spriteName, xStart: xStart, yStart: yStart )
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
}