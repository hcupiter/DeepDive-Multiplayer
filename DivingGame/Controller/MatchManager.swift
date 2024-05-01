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
    @Published var isGameFinish: Bool = false
    @Published var playerHasEnteredAPortal: Bool!
    
    @Published var portal: PortalModel!
    
    @Published var playerPeerId: String!
    @Published var controlledPlayer: PlayerModel!
    @Published var controlledPlayerOxygen: CGFloat = 100
    
    @Published var player1Id: String!
    @Published var player1Model: PlayerModel!
    
    @Published var player2Id: String!
    @Published var player2Model: PlayerModel!
    
    var connectionManager: MPConnectionManager!
    
    // things that not
    var isTheHost: Bool = false
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
    var sharkModel: SharkModel!
    var bombModel: BombModel!
    
    override func didMove(to view: SKView) {
        initializeObject()
        setControlledPlayer()
        self.physicsWorld.contactDelegate = self
        backgroundColor = SKColor.blueSky
        
        // set physics for the map
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        if controlledPlayer.id == player1Model.id {
            isTheHost = true
        }
        else {
            isTheHost = false
        }
    }
    
    // this function will run every frame
    override func update(_ currentTime: TimeInterval) {
        // spawn shark if it's player 1 or the host
        if isTheHost {
            sharkModel.spawnSharkWithinInterval(currentTime: currentTime)
            bombModel.spawnBomb()
        }
        
        // move player
        self.controlledPlayer.movePlayerByGyro(dx: self.gyro.x, dy: self.gyro.y, connectionManager: self.connectionManager)
        self.controlledPlayerOxygen = self.controlledPlayer.playerOxygen.playerOxygenLevel // this to change the value of player oxygen
                
        // check player's zone
        runZoneBehavior()
        
        // decrease player oxygen
        let tryDecreaseOxygen = self.controlledPlayer.playerOxygen.decreaseOxygen(currentTime)
        if(tryDecreaseOxygen == false){
            self.controlledPlayer.throwPlayerDeathEvent(connectionManager: connectionManager)
        }
        
    }
    
    func initializeObject(){
        inGame = 0
        isGameFinish = false
        playerHasEnteredAPortal = false
        
        //testing nodes
        sceneWidth = SKLabelNode(text: "width : \(size.width)")
        sceneWidth.position = CGPoint(x: size.width/2, y: size.height/2)
        
        sceneHeight = SKLabelNode(text: "height : \(size.height)")
        sceneHeight.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
        map = MapModel(matchManager: self)
        
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
        
        portal = PortalModel(matchManager: self)
        
        player1Model = PlayerModel(id: player1Id, initLocation: map.initLocation, mapNode: map.mapNode, matchManager: self)
        player2Model = PlayerModel(id: player2Id, initLocation: map.initLocation , mapNode: map.mapNode, matchManager: self)
        
        sharkTraps = true
        sharkModel = SharkModel(matchManager: self)
        bombModel = BombModel(matchManager: self)
        
        addChild(sceneWidth)
        addChild(sceneHeight)
        addChild(map.mapNode)
        addChild(player1Model.playerNode)
        addChild(player1Model.teamBox)
        addChild(player2Model.playerNode)
        addChild(player2Model.teamBox)
        portal.spawnPortal()
    }
    
    func setControlledPlayer(){
        if playerPeerId == player1Id {
            self.controlledPlayer = player1Model
        }
        else {
            self.controlledPlayer = player2Model
        }
        self.camera = controlledPlayer.cameraNode
        self.controlledPlayerOxygen = controlledPlayer.playerOxygen.playerOxygenLevel
    }
    
    func moveFoePlayer(foeId: String, foePosition: CGPoint) {
        if foeId == player1Id {
            player1Model.movePlayerByPosition(pos: foePosition)
        }
        else {
            player2Model.movePlayerByPosition(pos: foePosition)
        }
    }
    
    func runZoneBehavior(){
        // zone 1 behavior
        if(map.checkIfPlayerInZone1(player: controlledPlayer)){
            controlledPlayer.playerOxygen.oxygenDecreaseInterval = 1.5
        }
        // zone 2 behavior
        else if(map.checkIfPlayerInZone2(player: controlledPlayer)){
            controlledPlayer.playerOxygen.oxygenDecreaseInterval = 1
        }
        // zone 3 behavior
        else if(map.checkIfPlayerInZone3(player: controlledPlayer)){
            controlledPlayer.playerOxygen.oxygenDecreaseInterval = 0.5
        }
    }
    
    
    // this function will handle receiving data from player
    func handlePlayerEvent(playerEvent: MPPlayerEvent, connectionManager: MPConnectionManager){
        switch playerEvent.action {
        case .start:
            print("Start event")
            
        case .move:
            self.moveFoePlayer(foeId: playerEvent.playerId, foePosition: playerEvent.playerPosition)
            
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
    
    // this function will handle receiving entity data from host
    func handleEntityEvent(entityEvent: MPEntityEvent, connectionManager: MPConnectionManager){
        switch entityEvent.event {
        case .sharkSpawn:
            sharkModel.synchronizeSharkSpawnWithHost(position: entityEvent.position, entityTextureName: entityEvent.entityTextureName, destinationY: entityEvent.destinationY, speed: entityEvent.speed, direction: entityEvent.direction)
            
        case .bombSpawn:
            bombModel.synchronizeBombPlacingWithHost(position: entityEvent.position)
            
        case .portalSpawn:
            print("Portal Spawned")
            
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
        if ((firstBody.categoryBitMask & PhysicsCategory.player1 != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.player2 != 0)) {
            // player 1 collided with player 2
            handlePlayerCollision(player1: firstBody.node as? SKSpriteNode, player2: secondBody.node as? SKSpriteNode)
        } else if ((firstBody.categoryBitMask & PhysicsCategory.player2 != 0) &&
                   (secondBody.categoryBitMask & PhysicsCategory.player1 != 0)) {
            // player 2 collided with player 1
            handlePlayerCollision(player1: secondBody.node as? SKSpriteNode, player2: firstBody.node as? SKSpriteNode)
        }
    }
    
    func handlePlayerCollision(player1: SKSpriteNode?, player2: SKSpriteNode?) {
        if let player1 = player1, let player2 = player2 {
            // Apply a force to both players to repel them away from each other
            let repelForce = CGVector(dx: -player1.physicsBody!.velocity.dx, dy: -player1.physicsBody!.velocity.dy)
            player1.physicsBody?.applyImpulse(repelForce)
            player2.physicsBody?.applyImpulse(repelForce)
        }
    }
}

