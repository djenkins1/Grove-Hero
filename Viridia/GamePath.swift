//
//  GamePath.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/25/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class GamePath
{
	var xDestiny : CGFloat
	
	var yDestiny : CGFloat
	
	var xStart : CGFloat
	
	var yStart : CGFloat
	
	var baseSpeed : CGFloat
	
	init( x : CGFloat, y : CGFloat, speedInSeconds : CGFloat, obj : GameObj )
	{
		self.baseSpeed = speedInSeconds
		self.xDestiny = x
		self.yDestiny = y
		self.xStart = obj.sprite.position.x
		self.yStart = obj.sprite.position.y
		adjustSpeed( obj, otherThanZero: true )
	}
	
	//returns true if the objects still has distance to move or false otherwise
	func adjustSpeed( obj : GameObj, otherThanZero : Bool = false ) -> Bool
	{
		let xDist = abs( xDestiny - obj.sprite.position.x )
		let yDist = abs( yDestiny - obj.sprite.position.y )
		if ( xDist == 0 && yDist == 0 )
		{
			obj.horSpeed = 0
			obj.verSpeed = 0
			return false
		}
		
		if ( baseSpeed == 0 )
		{
			obj.horSpeed = 0
			obj.verSpeed = 0
			return false
		}
		
		let movingRight = ( xStart < xDestiny )
		let movingDown = ( yStart < yDestiny )
		if movingDown && obj.sprite.position.y > yDestiny
		{
			obj.verSpeed = 0
			obj.jumpTo( obj.sprite.position.x, y: yDestiny )
			return true
		}
		
		if ( movingRight && obj.sprite.position.x > xDestiny )
		{
			obj.horSpeed = 0
			obj.jumpTo( xDestiny, y: obj.sprite.position.y )
			return true
		}
		
		if ( otherThanZero )
		{
			let xScalar : CGFloat = ( xDestiny > obj.sprite.position.x ? 1 : -1 )
			let yScalar : CGFloat = ( yDestiny > obj.sprite.position.y ? 1 : -1 )

			obj.horSpeed = xScalar * ( xDist / baseSpeed )
			obj.verSpeed = yScalar * ( yDist / baseSpeed )
		}
		
		return true
	}
}