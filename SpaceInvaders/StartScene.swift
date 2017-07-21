//
//  StartScene.swift
//  SpaceInvaders
//
//  Created by Alan Muno on 21-07-17.
//  Copyright © 2017 alammm. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class StartScene: SKScene {
    
    
    var contentCreated = false
    
    override func didMove(to view: SKView) {
        if !self.contentCreated {
            self.initContent()
            self.contentCreated = true
        }
    }
    
    func initContent() {
        
        self.backgroundColor = SKColor.black
        
        let startGameLabel = SKLabelNode(fontNamed: "Futura")
        startGameLabel.fontSize = 22
        startGameLabel.fontColor = SKColor.green
        startGameLabel.text = "Tap to Start"
        startGameLabel.position = CGPoint(x: self.size.width/2, y: 0.5 * self.size.height)
        
        self.addChild(startGameLabel)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("go to GameScene")
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        gameScene.isGameBegin = true
        self.view?.presentScene(gameScene, transition: SKTransition.crossFade(withDuration: 1.0))
    }
}
