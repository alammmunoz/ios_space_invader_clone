//
//  GameScene.swift
//  SpaceInvaders
//
//  Created by Alan Muno on 13-07-17.
//  Copyright © 2017 alammm. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //variables de la partida
    var contentCreated = false
    
    enum InvaderType {
        case A, B, C
        
        static var size: CGSize {
            return CGSize(width: 24, height: 16)
        }
        
        static var name: String {
            return "invader"
        }
    }
    
    enum InvaderMovementDirection {
        case Right, Left, DownThenRight, DownThenLeft, None
        
    }
    
    enum BulletType {
        case InvaderBullet, SpaceShipBullet
    }
    
    var invaderMovementDirection: InvaderMovementDirection = .Right
    var lastUpdatedTime: CFTimeInterval = 0.0
    let timePerMove : CFTimeInterval = 1.0
    
    let kInvaderRowCount = 6
    let kInvaderColCount = 6
    let kInvaderSpacing  = CGSize(width: 15, height: 15)
    
    let kShipSize: CGSize = CGSize(width: 30, height: 16)
    let kShipName: String = "ship"
    
    let kScoreHudName = "score"
    let kHealthHudName = "health"
    
    let motionManager : CMMotionManager = CMMotionManager()
    
    var tapArray: [Int] = []
    
    let kSpaceShipBullet = "spaceShipBulletFired"
    let kInvaderBullet = "invaderBulletFired"
    let kBulletSize = CGSize(width: 4, height: 8)
    
    let kInvaderCategory: UInt32 = 0x1 << 0
    let kShipFireBulletCategory: UInt32 = 0x1 << 1
    let kShipCategory: UInt32 = 0x1 << 2
    let kInvaderFireBulletCategory: UInt32 = 0x1 << 3
    let kSceneEdgeCategory: UInt32 = 0x1 << 4
    
    var contactArray : [SKPhysicsContact] = []
    
    
    var cam = SKCameraNode()
    var player = SKSpriteNode()
    
    //configuracion de la escena
    override func didMove(to view: SKView) {
        if(!self.contentCreated) {
            self.initContent()
            self.contentCreated = true
            
            self.motionManager.startAccelerometerUpdates()
            self.physicsWorld.contactDelegate = self
            
        }
    }
    
    func initContent() {
        //fondo negro del espacio exterior
        self.backgroundColor = UIColor.black
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: (self.view?.frame)!)
        
        self.physicsBody!.categoryBitMask = kSceneEdgeCategory
        
        self.setupInvaders()
        self.setupShip()
        self.setupHud()
        
        self.cam.position = self.player.position
        self.cam.position.y = self.cam.position.y + (270)
        
        print("posicion 'y' camera: \(self.cam.position.y)")
    }
    
    
    func createInvaderOfType(invaderType: InvaderType) -> SKNode {
        var color: SKColor
        
        switch invaderType {
        case .A:
            color = SKColor.red
        case .B:
            color = SKColor.green
        case .C:
            color = SKColor.blue
            
        }
        
        
        
        let invader = SKSpriteNode(color: color, size: InvaderType.size)
        
        invader.name = InvaderType.name
        
        invader.physicsBody = SKPhysicsBody(rectangleOf: InvaderType.size)
        invader.physicsBody!.isDynamic = false
        invader.physicsBody!.categoryBitMask = kInvaderCategory
        invader.physicsBody!.contactTestBitMask = 0x0
        invader.physicsBody!.collisionBitMask = 0x0
        
        return invader
        
    }
    
    func setupInvaders() {
        
        let origin = CGPoint(x: (self.scene?.size.width)!/3, y: (self.scene?.size.height)!/2)
        
        for row in 0..<kInvaderRowCount {
            
            var invaderType: InvaderType = .A
            
            switch row%3 {
            case 0:
                invaderType = .A
            case 1:
                invaderType = .B
            case 2:
                invaderType = .C
            default:
                print("este caso es imposible")
            }
            
            var invaderPosition = origin
            
            invaderPosition.y =
                origin.y + CGFloat(row) * (InvaderType.size.height + kInvaderSpacing.height)
            
            for col in 0..<kInvaderColCount {
                let invader = createInvaderOfType(invaderType: invaderType)
                
                invaderPosition.x =
                    origin.x + CGFloat(col) * (InvaderType.size.width + kInvaderSpacing.width)
                
                invader.position = invaderPosition
                
                addChild(invader)
            }
        }
    }
    
    func createSpaceShip() -> SKNode {
        let spaceShip = SKSpriteNode(color: SKColor.white, size: kShipSize)
        
        spaceShip.name = kShipName
        
        return spaceShip;
    }
    
    func setupShip() {
        var spaceShip = createSpaceShip()
        
        spaceShip.position = CGPoint(x: size.width/2, y: kShipSize.height/2)
        
        self.player = spaceShip as! SKSpriteNode
        
        spaceShip.physicsBody = SKPhysicsBody(rectangleOf: self.kShipSize)
        spaceShip.physicsBody!.isDynamic = true
        spaceShip.physicsBody!.affectedByGravity = false
        spaceShip.physicsBody!.mass = 0.025
        
        spaceShip.physicsBody!.categoryBitMask = kShipCategory
        spaceShip.physicsBody!.contactTestBitMask = 0x0
        
        spaceShip.physicsBody!.collisionBitMask = kSceneEdgeCategory
        
        addChild(spaceShip)
        self.camera = cam
        //self.player.position.y = self.player.position.y + 180
        
    }
    
    func setupHud() {
        
        let scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel.name = kScoreHudName
        scoreLabel.fontSize = 22
        scoreLabel.fontColor = UIColor.purple
        scoreLabel.text = String(format: "Score:  %04u", 0)
        scoreLabel.position = CGPoint(x: frame.size.width/2, y: size.height - (25 + scoreLabel.frame.size.height/2))
        
        addChild(scoreLabel)
        
        let healthlabel = SKLabelNode(fontNamed: "Futura")
        healthlabel.name = kHealthHudName
        healthlabel.fontSize = 22
        healthlabel.fontColor = UIColor.red
        healthlabel.text = String(format: "Health: %.1f%%", 100.0)
        healthlabel.position = CGPoint(x: frame.size.width/2, y: size.height - (40 + scoreLabel.frame.size.height + healthlabel.frame.size.height/2))
        addChild(healthlabel)
    }
    
    func makeBulletOfType(bulletType: BulletType) -> SKNode {
        var bullet: SKNode
        
        switch bulletType {
        case .SpaceShipBullet:
            bullet = SKSpriteNode(color: SKColor.white, size: self.kBulletSize)
            bullet.name = kSpaceShipBullet
            
            bullet.physicsBody = SKPhysicsBody(rectangleOf: kBulletSize)
            bullet.physicsBody!.isDynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = self.kShipFireBulletCategory
            bullet.physicsBody!.contactTestBitMask = self.kInvaderCategory
            bullet.physicsBody!.collisionBitMask = 0x0
            
        case .InvaderBullet:
            bullet = SKSpriteNode(color: SKColor.purple, size: self.kBulletSize)
            bullet.name = kInvaderBullet
            
            bullet.physicsBody = SKPhysicsBody(rectangleOf: kBulletSize)
            bullet.physicsBody!.isDynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = self.kInvaderFireBulletCategory
            bullet.physicsBody!.contactTestBitMask = self.kShipCategory
            bullet.physicsBody!.collisionBitMask = 0x0
            
        }
        
        return bullet
    }
    
    
    //gestion de la interaccion
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    //gestion de disparos
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.tapCount == 1 {
                tapArray.append(1)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        self.contactArray.append(contact)
    }
    
    func fireBullet(bullet: SKNode, toPoint point: CGPoint, withDuration duration: CFTimeInterval, andSoundFileName soundFileName: String) {
        let bulletAction = SKAction.sequence([
            SKAction.move(to: point, duration: duration),
            SKAction.wait(forDuration: 5.0/60.0),
            SKAction.removeFromParent()
            ])
        
        let soundAction = SKAction.playSoundFileNamed(soundFileName, waitForCompletion: true)
        
        let groupedAction  = SKAction.group([bulletAction, soundAction])
        
        bullet.run(groupedAction)
        
        addChild(bullet)
        
        
    }
    
    func fireSpaceShipBullet() {
        let currentBullet = childNode(withName: kSpaceShipBullet)
        
        if currentBullet == nil {
            if let spaceShip = childNode(withName: kShipName) {
                let bullet = makeBulletOfType(bulletType: .SpaceShipBullet)
                
                bullet.position =
                    CGPoint(x: spaceShip.position.x, y: spaceShip.position.y + spaceShip.frame.size.height - bullet.frame.size.height/2)
                
                let bulletDestination = CGPoint(x: spaceShip.position.x, y: (self.view?.frame.size.height)! + bullet.frame.size.height/2)
                
                self.fireBullet(bullet: bullet, toPoint: bulletDestination, withDuration: 1.0, andSoundFileName: "ShipBullet.wav")
            }
        }
    }
    
    
    
    
    //actualizacion de la escena
    override func update(_ currentTime: TimeInterval) {
        
        self.processContactsForUpdate(currentime: currentTime)
        self.processUserTapForUpdate(currentTime: currentTime)
        self.processUserMovementForUpdate(currentTime: currentTime)
        self.moveInvadersForUpdate(currentTime: currentTime)
        self.fireInvadersBulletForUpdate(currentTime: currentTime)
        
    }
    
    func moveInvadersForUpdate(currentTime: CFTimeInterval) {
        if(currentTime - self.lastUpdatedTime < self.timePerMove) {
            return
        }
        
        self.determineInvaderMovementDirection()
        
        enumerateChildNodes(withName: InvaderType.name) { (node, stop) in
            switch self.invaderMovementDirection {
            case .Right:
                node.position = CGPoint(x: node.position.x + 10, y: node.position.y)
            case .Left:
                node.position = CGPoint(x: node.position.x - 10, y: node.position.y)
            case .DownThenLeft, .DownThenRight:
                node.position = CGPoint(x: node.position.x, y: node.position.y-10)
            case .None:
                break
            }
            
            self.lastUpdatedTime = currentTime
        }
    }
    
    func determineInvaderMovementDirection() {
        
        var movementDirection: InvaderMovementDirection = self.invaderMovementDirection
        
        enumerateChildNodes(withName: InvaderType.name) { (node, stop) in
            switch self.invaderMovementDirection {
            case .Right:
                if((node.frame.maxX) >= (node.scene?.size.width)! - 2) {
                    movementDirection = .DownThenLeft
                    stop.pointee = true
                }
            case .Left:
                if((node.frame.minX) <= 2) {
                    movementDirection = .DownThenRight
                    stop.pointee = true
                }
            case .DownThenLeft:
                movementDirection = .Left
                stop.pointee = true
            case .DownThenRight:
                movementDirection = .Right
                stop.pointee = true
            case .None:
                break
            }
        }
        
        if(movementDirection != self.invaderMovementDirection) {
            invaderMovementDirection = movementDirection
        }
    }
    
    func processUserMovementForUpdate(currentTime: CFTimeInterval) {
        
        if let ship = childNode(withName: kShipName) as? SKSpriteNode {
            if let data = motionManager.accelerometerData {
                
                if fabs(data.acceleration.x) > 0.2 {
                    
                    ship.physicsBody!.applyForce(CGVector(dx: 150.0 * CGFloat(data.acceleration.x), dy: 0))
                    
                }
            }
        }
    }
    
    func processUserTapForUpdate(currentTime: CFTimeInterval) {
        for tap in self.tapArray {
            if tap == 1 {
                self.fireSpaceShipBullet()
            }
            
            self.tapArray.remove(at: 0)
        }
    }
    
    func fireInvadersBulletForUpdate(currentTime: CFTimeInterval) {
        
        let existingBullet = childNode(withName: kInvaderBullet)
        
        if existingBullet == nil {
            var allTheInvaders: [SKNode] = []
            
            enumerateChildNodes(withName: InvaderType.name, using: { (node, stop) in
                allTheInvaders.append(node)
            })
            
            if allTheInvaders.count > 0 {
                let invaderIndex = Int(arc4random_uniform(UInt32(allTheInvaders.count)))
                let invader = allTheInvaders[invaderIndex]
                
                let bullet = self.makeBulletOfType(bulletType: .InvaderBullet)
                bullet.position =
                    CGPoint(x: invader.position.x, y: invader.position.y - invader.frame.size.height/2 + bullet.frame.size.height/2)
                
                let bulletDestination = CGPoint(x: invader.position.x, y: -bullet.frame.size.height/2)
                
                self.fireBullet(bullet: bullet, toPoint: bulletDestination, withDuration: 2.0, andSoundFileName: "InvaderBullet.wav")
            }
        }
    }
    
    func handleContact(contact: SKPhysicsContact) {
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil {
            return
        }
        
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        
        if nodeNames.contains(self.kShipName) && nodeNames.contains(self.kInvaderBullet) {
            print("nave tocada")
            self.run(SKAction.playSoundFileNamed("ShipHit.wav", waitForCompletion: false))
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }
        
        if nodeNames.contains(InvaderType.name) && nodeNames.contains(self.kSpaceShipBullet) {
            print("enemigo Derribado")
            self.run(SKAction.playSoundFileNamed("InvaderHit.wav", waitForCompletion: false))
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }
        
    }
    
    func processContactsForUpdate(currentime: CFTimeInterval) {
        for contact in self.contactArray {
            self.handleContact(contact: contact)
            if let indexContact = self.contactArray.index(of: contact) {
                self.contactArray.remove(at: indexContact)
            }
        }
    }
}
