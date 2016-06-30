//
//  GroundObj.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/19/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class GroundObj : GameObj
{
	var isTop : Bool
	
	var myPlant : PlantObj!
	
	var isShroomed = false
	
	var isSandy = false
	
	init( isTop : Bool, xStart: CGFloat, yStart: CGFloat )
	{
		self.isTop = isTop
		super.init( spriteName: GroundObj.getGrassSprite( isTop ) , xStart: xStart, yStart: yStart )
	}
	
	static func getGrassSprite( isTop : Bool ) -> String
	{
		return ( isTop ? "grassMid" : "grassCenter" )
	}
	
	//changes the ground to mycelium, if already mycelium changes to sand and kills off any plant growing above
	func damageMe()
	{
		if ( !isTop )
		{
			return
		}
		
		if ( isSandy )
		{
			if ( myScene != nil )
			{
				myScene!.playSoundEffect( Sounds.sandSmash )
				
				let spider = SpiderObj( xStart: sprite.position.x, yStart: sprite.position.y )
				spider.sprite.position.y += spider.sprite.frame.height * 1.5
				myScene.queueGameObject( spider )
			}

			return
		}
		
		if ( isShroomed )
		{
			changeSprite( "sandMid" )
			isSandy = true
			if ( myScene != nil )
			{
				myScene!.playSoundEffect( Sounds.createSand )
			}
			
			if ( myPlant != nil )
			{
				myPlant.makeDead()
				myPlant = nil
				if ( myScene != nil )
				{
					myScene!.playSoundEffect( Sounds.deadShroom )
				}
			}
			return
		}
		
		if ( myScene != nil )
		{
			myScene!.playSoundEffect( Sounds.createMycelium )
		}
		
		changeSprite( "stoneMid" )
		isShroomed = true
		if ( myPlant != nil )
		{
			myPlant!.changeToShroom()
			if ( myScene != nil )
			{
				myScene!.playSoundEffect( Sounds.createShroom )
			}
		}
	}
	
	//changes the ground back to grass if it was mycelium
	//if already grass does nothing
	//if sand and not mycelium it also does nothing
	func healMe()
	{
		if ( !isTop )
		{
			return
		}
		
		if ( isSandy )
		{
			return
		}
		
		if ( isShroomed )
		{
			changeSprite( "grassMid" )
			if ( myScene != nil )
			{
				myScene!.playSoundEffect( Sounds.healMycelium )
			}
			
			isShroomed = false
			if ( myPlant != nil )
			{
				myPlant.changeToPlant()
				if ( myScene != nil )
				{
					myScene!.playSoundEffect( Sounds.healShroom )
				}
			}
			return
		}
	}
	
	func rockMe()
	{
		if ( !isTop )
		{
			return
		}
		
		if ( myPlant != nil )
		{
			return
		}
		
		if ( myScene != nil )
		{
			myScene!.playSoundEffect( Sounds.createRock )
		}
		let myRock = RockObj( xStart: sprite.position.x, yStart: sprite.position.y )
		//myRock.sprite.position.y += myRock.sprite.frame.height
		myRock.myPath = GamePath( x: sprite.position.x, y: sprite.position.y + myRock.sprite.frame.height , speedInSeconds: CGFloat( 0.75 ), obj: myRock )
		self.myScene.queueGameObject( myRock )
	}
}