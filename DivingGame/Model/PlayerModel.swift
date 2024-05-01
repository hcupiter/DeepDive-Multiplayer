//
//  PlayerModel.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import Foundation
import SpriteKit

class PlayerModel: ObservableObject {
    @Published var id: String
    @Published var playerNode: SKSpriteNode
    var cameraNode: SKCameraNode
    var playerOxygen: Oxygen
    var mapNode: SKSpriteNode
    var teamBox: SKSpriteNode!
    var playerInitLocation: CGPoint! // to saves spawn location
    
    init(id: String, initLocation: CGPoint, mapNode: SKSpriteNode, matchManager: MatchManager){
        self.id = id
        self.playerOxygen = Oxygen()
        self.mapNode = mapNode
        cameraNode = SKCameraNode()
        cameraNode.position = initLocation
        cameraNode.setScale(1.5)
        
        playerNode = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 100))
        playerNode.position = initLocation
        playerInitLocation = initLocation
        playerInitLocation.y = initLocation.y
        if(self.id == matchManager.player1Id){
            playerInitLocation.x = initLocation.x - 50
            playerNode.position.x -= 50
        }
        else {
            playerInitLocation.x = initLocation.x + 50
            playerNode.position.x += 50
        }
        
        // init team flag
        teamBox = SKSpriteNode(color: UIColor.red, size: CGSize(width: 20, height: 20))
        teamBox.position.x = initLocation.x
        teamBox.position.y = initLocation.y + 75
        
        //setup player physics
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.texture = SKTexture(imageNamed: "diverDefault")
        playerNode.physicsBody?.isDynamic = true
        if(self.id == matchManager.player1Id){
            playerNode.physicsBody?.categoryBitMask = PhysicsCategory.player1
            playerNode.physicsBody?.contactTestBitMask = PhysicsCategory.shark | PhysicsCategory.bomb | PhysicsCategory.player2
            playerNode.physicsBody?.collisionBitMask = PhysicsCategory.shark | PhysicsCategory.player2
            teamBox.color = UIColor.red
        }
        else {
            playerNode.physicsBody?.categoryBitMask = PhysicsCategory.player2
            playerNode.physicsBody?.contactTestBitMask = PhysicsCategory.shark | PhysicsCategory.bomb | PhysicsCategory.player1
            playerNode.physicsBody?.collisionBitMask = PhysicsCategory.shark | PhysicsCategory.player1
            teamBox.color = UIColor.blue
        }
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func movePlayerByGyro(dx: CGFloat, dy: CGFloat, connectionManager: MPConnectionManager){
        // limit gyro movement so that it won't move very fast
        var movementX = dx
        if movementX < -0.5 {
            movementX = -0.5
        } else if movementX > 0.5 {
            movementX = 0.5
        }
        
        var movementY = dy
        if movementY < 0 {
            playerOxygen.playerOxygenLevel += 1
            movementY *= 2
        }
        else if movementY > 0.3 {
            movementY = 0.3
        }
        
        // calculate movement speed
        let movementFactor: CGFloat = 10 // adjust this factor to control the movement speed
        let movementXDistance = movementX * movementFactor
        let movementYDistance = movementY * movementFactor * -1
        
        let newX = playerNode.position.x + movementXDistance
        let newY = playerNode.position.y + movementYDistance
        
        // conditional to check so that the player won't go over boundary of the map
        if newX + playerNode.size.width / 2 <= mapNode.frame.maxX && newX - playerNode.size.width / 2 >= mapNode.frame.minX {
            playerNode.position.x = newX
        }
        else {
            playerNode.position = playerInitLocation
        }
        
        if newY + playerNode.size.height / 2 <= mapNode.frame.maxY && newY - playerNode.size.height / 2 >= mapNode.frame.minY {
            playerNode.position.y = newY
        }
        else {
            playerNode.position = playerInitLocation
        }
        
        cameraNode.position = playerNode.position
        teamBox.position.x = playerNode.position.x
        teamBox.position.y = playerNode.position.y + 75
        
        // send updates to other devices
        let playerEvent = MPPlayerEvent(action: .move, playerId: self.id, playerPosition: playerNode.position)
        connectionManager.send(playerEvent: playerEvent)
    }
    
    func movePlayerByPosition(pos: CGPoint){
        playerNode.position = pos
        teamBox.position.x = playerNode.position.x
        teamBox.position.y = playerNode.position.y + 75
    }

}

class Oxygen {
    var playerOxygenLevel: CGFloat
    let maxOxygenLevel: CGFloat = 100
    var oxygenDecreaseInterval: CGFloat
    var lastSavedOxygenTime: CGFloat!
    
    init(){
        playerOxygenLevel = 100
        oxygenDecreaseInterval = 1.5
    }
}
