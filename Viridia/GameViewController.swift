//
//  GameViewController.swift
//  Viridia
//
//  Created by Dilan Jenkins on 6/17/16.
//  Copyright (c) 2016 Dilan Jenkins. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController
{
	var currentState = GameState.Menu
	
	var musicPlayer: AVPlayer!
	
	var playMusicList = [Sounds]()
	
	var isMuted = false
	
	var reachedLoaded = false
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
		if ( !isMuted )
		{
			playMusic()
		}
		changeState( currentState )
		reachedLoaded = true
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
			if let scene = returnSceneFromState( toState )
			{
				// Configure the view.
				let skView = self.view as! SKView
				skView.showsFPS = true
				skView.showsNodeCount = true
				
				/* Sprite Kit applies additional optimizations to improve rendering performance */
				skView.ignoresSiblingOrder = true
				
				/* Set the scale mode to scale to fit the window */
				scene.scaleMode = .AspectFill
				scene.myController = self
				if ( !reachedLoaded )
				{
					skView.presentScene(scene)
				}
				else
				{
					let transition = SKTransition.fadeWithDuration( 1.0)
					skView.presentScene(scene, transition: transition )
				}
			}
		}
		else
		{
			print( "Could not change state to \(toState)" )
			return
		}
		

	}
	
	func returnSceneFromState( state : GameState ) -> GameScene?
	{
		let fileName = "GameScene"
		switch( state )
		{
		case .Play:
			return LevelScene( fileNamed: fileName )
		case .Menu:
			return MenuScene( fileNamed: fileName )
		default:
			return nil
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
	
	//plays the background music in a loop
	func playMusic()
	{
		playMusicList = Sounds.randomMusicList()
		musicPlayer = AVPlayer( playerItem: playMusicList[ 0 ].getItem() )
		musicPlayer.play()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: musicPlayer.currentItem )
	}
	
	//called when the player finishes a song
	func playerDidFinishPlaying(note: NSNotification)
	{
		if ( isMuted )
		{
			return
		}
		
		NSNotificationCenter.defaultCenter().removeObserver( note.object! )
		playMusicList.append( playMusicList.removeAtIndex( 0 ) )
		musicPlayer = AVPlayer( playerItem: playMusicList[ 0 ].getItem() )
		musicPlayer.play()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: musicPlayer.currentItem )
	}
}
