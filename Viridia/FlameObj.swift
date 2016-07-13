//
//  FlameObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/21/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class FlameObj : GameObj
{
	init( xStart : CGFloat, yStart: CGFloat )
	{
		super.init( spriteName: "flame" , xStart: xStart, yStart: yStart )
		self.dieOnCollide = false
		self.dieOutsideScreen = true
		self.sprite.zPosition = 20
		self.verSpeed = 150
	}
	
	override func collideEvent(other: GameObj)
	{
		if ( other.hasCollideEffect( self ) )
		{
			if ( myScene != nil )
			{
				myScene!.playSoundEffect( Sounds.flameHit )
				makeExplosion( other  )
			}
			makeDead()
		}
		
	}
	
	private func makeExplosion( other : GameObj )
	{
		if ( myScene == nil )
		{
			return
		}
		
		if ( isDead )
		{
			return
		}
		
		let explodeObj = ParticleObj( spriteName: "explosion", xStart: other.sprite.position.x, yStart: other.sprite.position.y )
		explodeObj.sprite.xScale = 0.1
		explodeObj.sprite.yScale = 0.1
		let secondsNeeded = 0.25
		let action = SKAction.scaleTo( 0.3 , duration: secondsNeeded )
		explodeObj.sprite.runAction( action )
		explodeObj.deathModeEvent( Int( secondsNeeded * 60 ) )
		myScene.queueGameObject( explodeObj )
	}
}