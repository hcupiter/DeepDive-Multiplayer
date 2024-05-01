//
//  MatchManager.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import Foundation
import SpriteKit
import MultipeerConnectivity


class MatchManager: SKScene, ObservableObject{
    // things that is shared between players
    @Published var inGame: Int!
    @Published var isGameFinish: Bool!
    @Published var playerHasEnteredAPortal: Bool!
    
    @Published var sharkList: [SharkModel]!
    @Published var bombList: [BombModel]!
    @Published var portal: PortalModel!
    
    @Published var playerPeerId: String!
    @Published var controlledPlayer: PlayerModel!
    
    @Published var player1Id: String!
    @Published var player1Model: PlayerModel!
    
    @Published var player2Id: String!
    @Published var player2Model: PlayerModel!

    var connectionManager: MPConnectionManager!
    
    // things that not
    var sceneWidth : SKLabelNode!
    var sceneHeight :SKLabelNode!
    var map : MapModel!
    var cameraNode : SKCameraNode!
    
    var gyro = GyroManager.shared
    
    var sharkSpawnInterval: TimeInterval! = 0.5
    var lastSavedSharkTime: TimeInterval!
    
    var section2LimitNode : SKSpriteNode!
    var section3LimitNode : SKSpriteNode!
    var mapDivider: SKSpriteNode!
    var xLimiter: SKSpriteNode!
    var yLimiter: SKSpriteNode!
    
    var sharkTraps: Bool = true
    
    override func didMove(to view: SKView) {
        initializeObject()
        setControlledPlayer()
        self.physicsWorld.contactDelegate = self
        backgroundColor = SKColor.blueSky
        
        // set physics for the map
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        // move player
        self.controlledPlayer.movePlayerByGyro(dx: self.gyro.x, dy: self.gyro.y, connectionManager: self.connectionManager)
    }
    
    func initializeObject(){
        inGame = 0
        isGameFinish = false
        playerHasEnteredAPortal = false
        
        sharkList = []
        bombList = []

        //testing nodes
        sceneWidth = SKLabelNode(text: "width : \(size.width)")
        sceneWidth.position = CGPoint(x: size.width/2, y: size.height/2)
        
        sceneHeight = SKLabelNode(text: "height : \(size.height)")
        sceneHeight.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
        map = MapModel()
        
        section2LimitNode = SKSpriteNode(color: UIColor.red, size: CGSize(width: map.mapNode.size.width, height: 10))
        section2LimitNode.position = CGPoint(x: 0, y: section2)
        
        section3LimitNode = SKSpriteNode(color: UIColor.orange, size: CGSize(width: map.mapNode.size.width, height: 10))
        section3LimitNode.position = CGPoint(x: 0, y: section3)
        
        mapDivider =  SKSpriteNode(color: UIColor.green, size: CGSize(width: 10, height: map.mapNode.size.height))
        mapDivider.position = CGPoint (x: map.mapNode.position.x / 2, y : 0)
        
        xLimiter = SKSpriteNode(color: UIColor.cyan, size: CGSize(width: map.mapNode.size.width, height: 10))
        xLimiter.position = CGPoint(x: 0, y: 0)
        
        yLimiter = SKSpriteNode(color: UIColor.cyan, size: CGSize(width: 10, height: map.mapNode.size.height))
        yLimiter.position = CGPoint(x: 0, y: 0)
        
        portal = PortalModel(section3LimitNode: section3LimitNode)
        
        player1Model = PlayerModel(id: player1Id, initLocation: map.initLocation, mapNode: map.mapNode)
        player2Model = PlayerModel(id: player2Id, initLocation: map.initLocation , mapNode: map.mapNode)
        
        sharkTraps = true
        
        addChild(sceneWidth)
        addChild(sceneHeight)
        addChild(map.mapNode)
        addChild(player1Model.playerNode)
        addChild(player2Model.playerNode)
    }
    
    func setControlledPlayer(){
        if playerPeerId == player1Id {
            self.controlledPlayer = player1Model
        }
        else {
            self.controlledPlayer = player2Model
        }
        self.camera = controlledPlayer.cameraNode
    }
    
    func moveFoePlayer(foeId: String, foePosition: CGPoint) {
        if foeId == player1Id {
            player1Model.movePlayerByPosition(pos: foePosition)
        }
        else {
            player2Model.movePlayerByPosition(pos: foePosition)
        }
    }
    
    
    // this function will handle receiving data
    func handleGameEvent(gameEvent: MPGameEvent, connectionManager: MPConnectionManager){
        switch gameEvent.action {
            case .start:
                print("Start event")
            
            case .move:
            self.moveFoePlayer(foeId: gameEvent.playerId, foePosition: gameEvent.playerPosition)
            
            case .reset:
                print("Reset")
            
            case .end:
            connectionManager.session.disconnect()
            
            case .hit:
                print("Got hit")
            
            case .death:
                print("death")
        }
    }
}

extension MatchManager: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // get collided objects
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // define the collided object
        if ((firstBody.categoryBitMask & PhysicsCategory.player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.player == 0)) {
            if let player = firstBody.node as? SKSpriteNode,
               let object = secondBody.node as? SKSpriteNode {
//                playerCollideWithObject(player: player, object: object)
            }
        }
    }
    
    
}
