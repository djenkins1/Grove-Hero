//
//  Sounds.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/26/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import AVFoundation

class Sounds
{
	static let healShroom = "HealShroom.wav"
	
	static let rockLives = "RockLives.wav"
	
	static let firePlantHit = "FirePlantHit.wav"
	
	static let flameHit = "FlameHit.wav"
	
	static let boxHit = "BoxHit.wav"
	
	static let healMycelium = "HealMycelium.wav"
	
	static let loseSound = "LoseSound.wav"
	
	static let createMycelium = "MycelCreate.wav"
	
	static let createRock = "RockCreate.wav"
	
	static let deadRock = "RockDie.wav"
	
	static let lostRock = "RockLost.wav"
	
	static let createSand = "SandCreate.wav"
	
	static let sandMonster = "SandMonster.wav"
	
	static let sandSmash = "SandSmash.wav"
	
	static let createShroom = "ShroomCreate.wav"
	
	static let deadShroom = "ShroomDie.wav"
	
	static let winSound = "WinSound.wav"
	
	var name: String
	var type: String
	
	init( name: String, type: String )
	{
		self.name = name
		self.type = type
	}
	
	static func musicList() -> Array<Sounds>
	{
		var toReturn = [Sounds]()
		toReturn.append( Sounds( name: "mushroomDance" , type: "mp3" ) )
		toReturn.append( Sounds( name: "oneSong" , type: "mp3" ) )
		toReturn.append( Sounds( name: "sunshine" , type: "mp3" ) )
		return toReturn
	}
	
	static func randomMusicList() -> [Sounds]
	{
		var first = musicList()
		var toReturn = [Sounds]()
		while first.count > 0
		{
			let indexToTake = Int(arc4random_uniform( UInt32(first.count) ))
			toReturn.append( first.removeAtIndex( indexToTake ) )
		}
		
		return toReturn
	}
	
	func getItem() -> AVPlayerItem
	{
		let urlPath = NSBundle.mainBundle().pathForResource( self.name , ofType: self.type )
		let fileURL = NSURL(fileURLWithPath:urlPath!)
		return AVPlayerItem(URL:fileURL)
	}
}