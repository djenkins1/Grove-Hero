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
	var boxSpeedInSeconds : CGFloat { get }// = 10
	
	var fireCooldownInterval : CGFloat { get }// = 3
	
	var firePlantsPerTenGround : Int { get }// = 2
	
	var plantsPerTenGround : Int { get }// = 4
	
	var rocksPerTenGround : Int { get }// = 2
	
	var spiderEatSpeedInSecs : CGFloat { get }
	
	var boxSpawnRateHigh : UInt32 { get }
	
	var boxSpawnRateLow : UInt32 { get }
	
	var boxChanceOfBomb : UInt32 { get }
	
	var secondsBetweenSpawns : CGFloat { get }
}

class EasyDifficulty : DifficultyConstant
{
	var boxSpeedInSeconds : CGFloat
	
	var fireCooldownInterval : CGFloat
	
	var firePlantsPerTenGround : Int
	
	var plantsPerTenGround : Int
	
	var rocksPerTenGround : Int
	
	var spiderEatSpeedInSecs : CGFloat
	
	var boxSpawnRateHigh : UInt32
	
	var boxSpawnRateLow : UInt32
	
	var boxChanceOfBomb : UInt32
	
	var secondsBetweenSpawns : CGFloat
	
	init()
	{
		boxSpeedInSeconds = 10
		fireCooldownInterval = 3
		firePlantsPerTenGround = 2
		plantsPerTenGround = 5
		rocksPerTenGround = 3
		spiderEatSpeedInSecs = 2
		boxSpawnRateHigh = 5
		boxSpawnRateLow = 3
		boxChanceOfBomb = 5
		secondsBetweenSpawns = 1.2
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
	
	var boxSpawnRateHigh : UInt32
	
	var boxSpawnRateLow : UInt32
	
	var boxChanceOfBomb : UInt32
	
	var secondsBetweenSpawns : CGFloat

	init()
	{
		boxSpeedInSeconds = 8
		fireCooldownInterval = 4
		firePlantsPerTenGround = 2
		plantsPerTenGround = 4
		rocksPerTenGround = 2
		spiderEatSpeedInSecs = 1.5
		boxSpawnRateHigh = 4
		boxSpawnRateLow = 2
		boxChanceOfBomb = 8
		secondsBetweenSpawns = 1
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
	
	var boxSpawnRateHigh : UInt32
	
	var boxSpawnRateLow : UInt32
	
	var boxChanceOfBomb : UInt32
	
	var secondsBetweenSpawns : CGFloat

	init()
	{
		boxSpeedInSeconds = 5
		fireCooldownInterval = 6
		firePlantsPerTenGround = 1
		plantsPerTenGround = 3
		rocksPerTenGround = 1
		spiderEatSpeedInSecs = 1
		boxSpawnRateHigh = 4
		boxSpawnRateLow = 3
		boxChanceOfBomb = 12
		secondsBetweenSpawns = 0.8
	}
}