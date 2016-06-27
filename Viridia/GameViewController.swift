//
//  GameViewController.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/17/16.
//  Copyright (c) 2016 Dilan Jenkins. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController
{
	var currentState = GameState.Play
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
		changeState( currentState )
    }

    override func shouldAutorotate() -> Bool
	{
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
	{
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
		{
            return .AllButUpsideDown
        }
		else
		{
            return .All
        }
    }

    override func didReceiveMemoryWarning()
	{
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool
	{
        return true
    }
	
	//changes the games state to the state provided and presents the associated scene
	func changeState( toState : GameState )
	{
		let fileName = fileNameFromState( toState )
		if fileName != nil
		{
			if let scene = GameScene( fileNamed: fileName! )
			{
				// Configure the view.
				let skView = self.view as! SKView
				skView.showsFPS = true
				skView.showsNodeCount = true
				
				/* Sprite Kit applies additional optimizations to improve rendering performance */
				skView.ignoresSiblingOrder = true
				
				/* Set the scale mode to scale to fit the window */
				scene.scaleMode = .AspectFill
				skView.presentScene(scene)
			}
		}
		else
		{
			print( "Could not change state to \(toState)" )
			return
		}
		

	}
	
	//returns the Scene.swift file that corresponds to the state provided or nil otherwise
	func fileNameFromState( state : GameState ) -> String?
	{
		switch( state )
		{
		case .Play:
			return "GameScene"
		case .Menu:
			return "MenuScene"
		default:
			return nil
		}
	}
	
}
