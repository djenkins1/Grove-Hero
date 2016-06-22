//
//  FirePlant.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/21/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class FirePlant : PlantObj
{
	var shouldFireOnUpdate = false
	
	var coolDownState = 3
	
	var timer : Int = 0
	
	//number of seconds between sprite changes for cool down
	let coolDownInterval = 2
	
	override init(xStart: CGFloat, yStart: CGFloat)
	{
		super.init( spriteName : "firePlant3" , xStart: xStart, yStart: yStart )
	}
	
	override func updateEvent(scene: GameScene, currentFPS: Int)
	{
		timer = timer + 1
		if ( timer >= currentFPS * coolDownInterval )
		{
			timer = 0
			changeCoolDown( min( coolDownState + 1 , 3 ) )
		}
		
		if ( shouldFireOnUpdate )
		{
			shouldFireOnUpdate = false
			changeCoolDown( 1 )
			createFire( scene )
			timer = 0
		}
	}
	
	private func createFire( scene : GameScene )
	{
		let flame = FlameObj( xStart: sprite.position.x , yStart: sprite.position.y )
		scene.queueGameObject( flame )
	}
	
	private func changeCoolDown( newCoolDown : Int )
	{
		if ( newCoolDown < 0 || newCoolDown > 3 )
		{
			return
		}
		coolDownState = newCoolDown
		changeSprite( "firePlant\(coolDownState)" )
	}
	
	override func touchEvent(location: CGPoint)
	{
		if ( canFire() )
		{
			shouldFireOnUpdate = true
		}
		else
		{
			timer -= 1
		}
	}
	
	private func canFire() -> Bool
	{
		return coolDownState == 3
	}
	
	override func hasCollideEffect(other: GameObj) -> Bool
	{
		return true
	}
}