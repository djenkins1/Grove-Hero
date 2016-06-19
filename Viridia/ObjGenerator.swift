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
}
