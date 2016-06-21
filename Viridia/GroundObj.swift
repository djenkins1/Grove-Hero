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
			let plantObj = PlantObj(xStart: sprite.position.x, yStart: sprite.position.y )
			plantObj.sprite.position.y += plantObj.sprite.frame.height
			scene.addGameObject( plantObj )
		}
		return self
	}
	
	override func collideEvent(other: GameObj)
	{
		super.collideEvent( other )
		if ( isDead )
		{
			return
		}
		
		sprite.texture = SKTexture(imageNamed:"sandMid")
		
	}
}
