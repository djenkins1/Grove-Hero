//
//  ObjGenerator.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/19/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class ObjGenerator
{
	var stepsSinceGenerated : Int = 0
	
	var readyToGenerate = false
	
	var stepsNeeded : Int = 20
	
	let roomWidth : CGFloat
	
	let roomHeight : CGFloat
	
	var totalGenerated : Int
	
	var scene : GameScene!
	
	init( screenWidth : CGFloat, screenHeight : CGFloat )
	{
		self.roomHeight = screenHeight
		self.roomWidth = screenWidth
		self.totalGenerated = 0
	}
	
	func createEvent( scene : GameScene ) -> ObjGenerator
	{
		self.scene = scene
		return self
	}
	
	func incrementSteps()
	{
		stepsSinceGenerated += 1
		if ( stepsSinceGenerated >= stepsNeeded )
		{
			stepsSinceGenerated = 0
			readyToGenerate = true
		}
	}
	
	func generate() -> GameObj!
	{
		readyToGenerate = false
		return nil
	}
	
	func primePump()
	{
		self.stepsSinceGenerated = Int( ceil( Double(stepsNeeded) * 0.95 ) )
	}
}
