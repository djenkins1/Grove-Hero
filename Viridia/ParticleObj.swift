//
//  ParticleObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/12/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class ParticleObj : GameObj
{
	override func createEvent(scene: GameScene) -> GameObj
	{
		super.createEvent( scene )
		sprite.anchorPoint = CGPoint( x: 0.5, y: 0.5 )
		sprite.zPosition = 15
		return self
	}
	
	override func hasCollideEffect( other : GameObj ) -> Bool
	{
		return false
	}
}