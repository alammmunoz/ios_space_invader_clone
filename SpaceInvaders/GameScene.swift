//
//  GameScene.swift
//  SpaceInvaders
//
//  Created by Alan Muno on 13-07-17.
//  Copyright © 2017 alammm. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //variables de la partida
    var contentCreated = false
    
    
    //configuracion de la escena
    override func didMove(to view: SKView) {
        if(!self.contentCreated) {
            self.initContent()
            self.contentCreated = true
        }
    }
    
    func initContent() {
        //fondo negro del espacio exterior
        self.backgroundColor = UIColor.black
    }
    
    
    //gestion de la interaccion
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    //actualizacion de la escena
    override func update(_ currentTime: TimeInterval) {
        
    }
}
