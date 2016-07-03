//
//  DifficultyConstant.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/2/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

protocol DifficultyConstant
{
	var boxSpeedInSeconds : CGFloat { get set }// = 10
	
	var fireCooldownInterval : CGFloat { get set }// = 3
	
	var firePlantsPerTenGround : Int { get set }// = 2
	
	var plantsPerTenGround : Int { get set }// = 4
	
	var rocksPerTenGround : Int { get set }// = 2
	
	var spiderEatSpeedInSecs : CGFloat { get set }
}

class EasyDifficulty : DifficultyConstant
{
	var boxSpeedInSeconds : CGFloat
	
	var fireCooldownInterval : CGFloat
	
	var firePlantsPerTenGround : Int
	
	var plantsPerTenGround : Int
	
	var rocksPerTenGround : Int
	
	var spiderEatSpeedInSecs : CGFloat
	
	init()
	{
		boxSpeedInSeconds = 10
		fireCooldownInterval = 3
		firePlantsPerTenGround = 2
		plantsPerTenGround = 5
		rocksPerTenGround = 3
		spiderEatSpeedInSecs = 2
	}
}

class MidDifficulty : DifficultyConstant
{
	var boxSpeedInSeconds : CGFloat
	
	var fireCooldownInterval : CGFloat
	
	var firePlantsPerTenGround : Int
	
	var plantsPerTenGround : Int
	
	var rocksPerTenGround : Int
	
	var spiderEatSpeedInSecs : CGFloat

	init()
	{
		boxSpeedInSeconds = 8
		fireCooldownInterval = 4
		firePlantsPerTenGround = 2
		plantsPerTenGround = 4
		rocksPerTenGround = 2
		spiderEatSpeedInSecs = 1.5
	}
}

class HardDifficulty : DifficultyConstant
{
	var boxSpeedInSeconds : CGFloat
	
	var fireCooldownInterval : CGFloat
	
	var firePlantsPerTenGround : Int
	
	var plantsPerTenGround : Int
	
	var rocksPerTenGround : Int
	
	var spiderEatSpeedInSecs : CGFloat

	init()
	{
		boxSpeedInSeconds = 5
		fireCooldownInterval = 6
		firePlantsPerTenGround = 1
		plantsPerTenGround = 3
		rocksPerTenGround = 1
		spiderEatSpeedInSecs = 1
	}
}