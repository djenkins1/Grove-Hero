//
//  SaveAdaptor.swift
//  Viridia
//
//  Created by Dilan Jenkins on 7/14/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class SaveAdaptor
{
	let defaults = NSUserDefaults.standardUserDefaults()
	
	func getMuteStatus() -> Bool
	{
		return defaults.boolForKey( StringConst.Muted.rawValue )
	}
	
	func setMuteStatus( newStatus : Bool )
	{
		defaults.setBool( newStatus, forKey: StringConst.Muted.rawValue )
	}
	
	//returns the best score for the victory/difficulty pair provided
	//	returns 0 if the best score was missing for the pair provided
	func getBestScore( victCond : VictoryCondition , difCons : DifficultyConstant ) -> Int
	{
		let myKey = "\(victCond.myName())_\(difCons.myName())"
		return defaults.integerForKey( myKey )
	}
	
	//saves the new score as the best score for the victory/difficulty pair provided
	func setBestScore( newScore : Int, victCond : VictoryCondition, difCons : DifficultyConstant )
	{
		let myKey = "\(victCond.myName())_\(difCons.myName())"
		defaults.setInteger( newScore, forKey: myKey )
	}
	
	//returns true if the score provided is better then the saved for the victory/difficulty pair provided
	func compareBestScore( newScore : Int, victCond : VictoryCondition, difCons : DifficultyConstant ) -> Bool
	{
		return ( newScore > getBestScore( victCond, difCons : difCons ) )
	}
	
	//returns the farthest stage that the player has gotten to on the tutorial
	func getTutorialStage() -> TutorialStage
	{
		let myStageKey = defaults.objectForKey( StringConst.Tutored.rawValue ) as? String ?? ""
		
		if let myStage = TutorialStage( rawValue : myStageKey )
		{
			return myStage
		}
		else
		{
			return TutorialStage.first()
		}
	}
	
	//saves the stage provided as the farthest stage the player has gotten to in the tutorial
	func setTutorialStage( newStage : TutorialStage )
	{
		defaults.setObject( newStage.rawValue, forKey: StringConst.Tutored.rawValue )
	}
	
	func setFavoriteMode( myMode : VictoryCondition )
	{
		defaults.setObject( myMode.myName(), forKey : StringConst.FavMode.rawValue )
	}
	
	func setFavoriteDifficulty( myDifficulty : DifficultyConstant )
	{
		defaults.setObject( myDifficulty.myName(), forKey : StringConst.FavDifficulty.rawValue )
	}
	
	func getFavoriteMode() -> VictoryCondition
	{
		let myFav = defaults.objectForKey( StringConst.FavMode.rawValue ) as? String ?? ""
		switch( myFav )
		{
		case TimeVictory().myName():
			return TimeVictory()
		case BoxVictory().myName():
			return BoxVictory()
		default:
			return BoxVictory()
		}
	}
	
	func getFavoriteDifficulty() -> DifficultyConstant
	{
		let myFav = defaults.objectForKey( StringConst.FavDifficulty.rawValue ) as? String ?? ""
		switch( myFav )
		{
		case EasyDifficulty().myName():
			return EasyDifficulty()
		case MidDifficulty().myName():
			return MidDifficulty()
		case HardDifficulty().myName():
			return HardDifficulty()
		default:
			return EasyDifficulty()
		}
	}
}


enum StringConst : String
{
	case Muted
	case Tutored
	case FavMode
	case FavDifficulty
	
	//returns a star unicode symbol
	static func getStarText() -> String
	{
		return "\u{2605}"
	}
}