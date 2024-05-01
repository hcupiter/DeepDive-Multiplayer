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
    
    init(id: String, initLocation: CGPoint, mapNode: SKSpriteNode){
        self.id = id
        self.playerOxygen = Oxygen()
        self.mapNode = mapNode
        cameraNode = SKCameraNode()
        cameraNode.position = initLocation
        cameraNode.setScale(10)
        
        playerNode = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 100))
        playerNode.position = initLocation
        
        //setup player physics
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.texture = SKTexture(imageNamed: "diverDefault")
        playerNode.physicsBody?.isDynamic = true
        playerNode.physicsBody?.categoryBitMask = PhysicsCategory.player
        playerNode.physicsBody?.contactTestBitMask = PhysicsCategory.shark | PhysicsCategory.bomb
        playerNode.physicsBody?.collisionBitMask = PhysicsCategory.shark
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
        
        if newY + playerNode.size.height / 2 <= mapNode.frame.maxY && newY - playerNode.size.height / 2 >= mapNode.frame.minY {
            playerNode.position.y = newY
        }
        
        cameraNode.position = playerNode.position
        
        // send updates to other devices
        let playerEvent = MPPlayerEvent(action: .move, playerId: self.id, playerPosition: playerNode.position)
        connectionManager.send(playerEvent: playerEvent)
    }
    
    func movePlayerByPosition(pos: CGPoint){
        playerNode.position = pos
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
