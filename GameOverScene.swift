//
//  GameOverScene.swift
//  SpaceInvaders
//
//  Created by Alan Muno on 21-07-17.
//  Copyright © 2017 alammm. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    
    var contentCreated = false
    
    override func didMove(to view: SKView) {
        if !self.contentCreated {
            self.initContent()
            self.contentCreated = true
        }
    }
    
    func initContent() {
        
        self.backgroundColor = SKColor.black
        
        let gameOverLabel = SKLabelNode(fontNamed: "Futura")
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: 2.0/3.0 * self.size.height)
        
        self.addChild(gameOverLabel)
        
        
        let playAgainLabel = SKLabelNode(fontNamed: "Futura")
        playAgainLabel.fontSize = 22
        playAgainLabel.fontColor = SKColor.white
        playAgainLabel.text = "Tap to play again"
        playAgainLabel.position = CGPoint(x: self.size.width/2, y: 1.0/3.0 * self.size.height)
        
        self.addChild(playAgainLabel)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.showVideo()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        gameScene.isGameBegin = true
        
        self.view?.presentScene(gameScene, transition: SKTransition.crossFade(withDuration: 1.0))
    }
}
