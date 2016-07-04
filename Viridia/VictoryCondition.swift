//
//  VictoryCondition.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/4/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

protocol VictoryCondition
{
	func hasWon( scene : GameScene ) -> Bool
}

class BoxVictory : VictoryCondition
{
	func hasWon( scene : GameScene ) -> Bool
	{
		let totalToGenerate = 15
		let generatedLost = scene.objectsDestroyed[ BombBox( xStart: 0, yStart: 0).className() ]
		return ( generatedLost != nil && generatedLost >= totalToGenerate)
	}
}