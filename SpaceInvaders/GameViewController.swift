//
//  GameViewController.swift
//  SpaceInvaders
//
//  Created by Alan Muno on 13-07-17.
//  Copyright © 2017 alammm. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.size = view.frame.size
                // Present the scene
                view.presentScene(scene)
            }
            
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        
            
            //gestion de la pausa del videojuego
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationWillResignActive), name: .UIApplicationWillResignActive, object: nil)
            
            //gestion de la vuelta de pausa
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        }
    }
    
    func handleNotificationWillResignActive(notification: NSNotification) {
        let view = self.view as! SKView
        view.isPaused = true
        print("paused game")
    }
    
    func handleNotificationDidBecomeActive(notification: NSNotification) {
        let view = self.view as! SKView
        view.isPaused = false
        print("become active game")
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
