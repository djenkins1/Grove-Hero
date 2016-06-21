//
//  GroundObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/19/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class GroundObj : GameObj
{
	var isTop : Bool
	
	var myPlant : PlantObj!
	
	var isShroomed = false
	
	var isSandy = false
	
	init( isTop : Bool, xStart: CGFloat, yStart: CGFloat )
	{
		self.isTop = isTop
		super.init( spriteName: GroundObj.getSprite( isTop ) , xStart: xStart, yStart: yStart )
	}
	
	static func getSprite( isTop : Bool ) -> String
	{
		return ( isTop ? "grassMid" : "grassCenter" )
	}
	
	override func createEvent(scene: GameScene) -> GameObj
	{
		super.createEvent( scene )
		if ( isTop && arc4random_uniform( 3 ) == 0  )
		{
			if ( arc4random_uniform( 5 ) == 0  )
			{
				let rockObj = RockObj(xStart: sprite.position.x, yStart: sprite.position.y )
				rockObj.sprite.position.y += rockObj.sprite.frame.height
				scene.addGameObject( rockObj )
			}
			else
			{
				myPlant = PlantObj(xStart: sprite.position.x, yStart: sprite.position.y )
				myPlant!.sprite.position.y += myPlant!.sprite.frame.height
				scene.addGameObject( myPlant! )
			}
		}
		return self
	}
	
	//changes the ground to mycelium, if already mycelium changes to sand and kills off any plant growing above
	func damageMe()
	{
		if ( !isTop )
		{
			return
		}
		
		if ( isShroomed )
		{
			sprite.texture = SKTexture(imageNamed:"sandMid")
			isSandy = true
			if ( myPlant != nil )
			{
				myPlant.makeDead()
			}
			return
		}
		
		sprite.texture = SKTexture(imageNamed:"stoneMid")
		isShroomed = true
		if ( myPlant != nil )
		{
			myPlant!.changeToShroom()
		}
	}
	
	//changes the ground back to grass if it was mycelium
	//if already grass does nothing
	//if sand and not mycelium it also does nothing
	func healMe()
	{
		if ( !isTop )
		{
			return
		}
		
		if ( isSandy )
		{
			return
		}
		
		if ( isShroomed )
		{
			sprite.texture = SKTexture(imageNamed:"grassMid")
			isShroomed = false
			if ( myPlant != nil )
			{
				myPlant.changeToPlant()
			}
			return
		}
	}
}