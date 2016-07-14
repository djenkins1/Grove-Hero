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
	
	var secondsNeeded : CGFloat = 1
	
	let roomWidth : CGFloat
	
	let roomHeight : CGFloat
	
	var scene : GameScene!
	
	init( screenWidth : CGFloat, screenHeight : CGFloat )
	{
		self.roomHeight = screenHeight
		self.roomWidth = screenWidth
	}
	
	func createEvent( scene : GameScene ) -> ObjGenerator
	{
		self.scene = scene
		return self
	}
	
	func incrementSteps( currentFPS : Int )
	{
		stepsSinceGenerated += 1
		if ( CGFloat( stepsSinceGenerated ) >= stepsNeeded( currentFPS ) )
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
		self.stepsSinceGenerated = Int( ceil( 60 * 0.95 ) )
	}
	
	func stepsNeeded( currentFPS : Int ) -> CGFloat
	{
		return secondsNeeded * CGFloat( currentFPS )
	}
	
	func entryGenerate() -> ObjGenerator
	{
		return self
	}
}
