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
	
	let maxLives = 3
	
	//number of seconds between sprite changes for cool down
	var coolDownInterval : CGFloat = 2
	
	override init(xStart: CGFloat, yStart: CGFloat)
	{
		super.init( spriteName : "firePlant3" , xStart: xStart, yStart: yStart )
		lives = 3
	}
	
	override func createEvent(scene: GameScene) -> GameObj
	{
		super.createEvent( scene )
		coolDownInterval = scene.myController!.diffiCons.fireCooldownInterval
		return self
	}
	
	override func updateEvent(scene: GameScene, currentFPS: Int)
	{
		super.updateEvent( scene , currentFPS: currentFPS )
		timer = timer + 1
		if ( timer >= coolDownTime( currentFPS ) )
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
	
	private func coolDownTime( currentFPS : Int ) -> Int
	{
		let secsPerLifeLost = 1
		let added = secsPerLifeLost * ( maxLives - lives )
		return Int( floor( CGFloat( currentFPS ) * coolDownInterval ) ) + ( added * currentFPS )
	}
	
	private func createFire( scene : GameScene )
	{
		//70 wide by 100 tall = fireplant
		//41 wide by 80 tall = flame
		let flame = FlameObj( xStart: sprite.position.x , yStart: sprite.position.y )
		flame.sprite.position.x += ( floor( flame.sprite.frame.width / 2 ) - 1.5 )
		flame.sprite.position.y += ( flame.sprite.frame.height * 1.2 )
		scene.queueGameObject( flame )
	}
	
	func spriteFromLife()
	{
		if ( lives > maxLives || lives < 0 )
		{
			return
		}
		
		let maxLivesDoubled  = CGFloat( maxLives * 2 )
		let newScale = ( CGFloat(lives) / maxLivesDoubled ) + 0.5
		sprite.yScale = newScale
	}
	
	override func damage()
	{
		super.damage()
		if ( !isDead )
		{
			myScene.playSoundEffect( Sounds.firePlantHit )
			spriteFromLife()
		}
		else
		{
			if ( myScene != nil )
			{
				myScene.playSoundEffect( Sounds.fireDead )
			}
		}
		
	}
	
	private func changeCoolDown( newCoolDown : Int )
	{
		if ( newCoolDown <= 0 || newCoolDown > 3 || coolDownState == newCoolDown )
		{
			return
		}
		coolDownState = newCoolDown
		changeSprite( "firePlant\(coolDownState)" )
		if ( coolDownState == 3 && myScene != nil )
		{
			myScene.playSoundEffect( Sounds.fireReady )
		}
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
		if ( other is FlameObj )
		{
			return false
		}
		return true
	}
	
	override func collideEvent(other: GameObj)
	{
		if ( other is BombBox )
		{
			timer = 0
			changeCoolDown( 1 )
			damage()
		}
		
		if ( other is HealBox )
		{
			if ( lives == maxLives )
			{
				timer = 0
				if ( coolDownState != 3 )
				{
					changeCoolDown( 3 )
				}
				else
				{
					shouldFireOnUpdate = true
				}
			}
			else
			{
				lives = min( lives + 1, maxLives )
				spriteFromLife()
				if ( myScene != nil )
				{
					myScene.playSoundEffect( Sounds.healShroom )
				}
			}
		}
		
	}
}