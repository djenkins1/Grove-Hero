//
//  MenuScene.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/26/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene : SKScene
{
	var allButtons = [UIButton]()
	//function first called when the scene is viewed
	override func didMoveToView(view: SKView)
	{
		
	}
	
	/* Called before each frame is rendered */
	override func update(currentTime: CFTimeInterval)
	{
		
	}
	
	/* Called when a touch begins */
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		
	}
	
	override func willMoveFromView(view: SKView)
	{
		super.willMoveFromView( view )
		while allButtons.count > 0
		{
			let button = allButtons.removeFirst()
			button.removeFromSuperview()
		}
	}
}