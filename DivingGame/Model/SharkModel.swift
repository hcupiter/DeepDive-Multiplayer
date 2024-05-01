//
//  Shark.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import Foundation
import SpriteKit

class SharkModel {
    var sharkSpawnInterval: CGFloat
    var lastSavedSharkTime: TimeInterval!
    var matchManager: MatchManager!
    
    init(matchManager: MatchManager){
        sharkSpawnInterval = 0.5
        self.matchManager = matchManager
    }
    
    func spawnSharkWithinInterval(currentTime: TimeInterval){
        if lastSavedSharkTime == nil {
            lastSavedSharkTime = currentTime
        }
        else if abs(lastSavedSharkTime - currentTime) >= sharkSpawnInterval {
            self.addSharks()
//            print("Shark spawned")
            lastSavedSharkTime = nil
        }
    }
    
    func addSharks(){
        let sharkImage = getRandomString()
        let directionRight = sharkImage.contains("Right") ? true : false
        let sharkNode = SKSpriteNode(imageNamed: sharkImage)
        sharkNode.name = "Shark"
        
        //shark Y coordinate spawn location
        let sharkYPositon = random(
            min: matchManager.section2LimitNode.position.y - sharkNode.size.height,
            max: mapBottomSide + sharkNode.size.height
        )
        let sharkXPosition = directionRight ? mapLeftSide - sharkNode.size.width : mapRightSide + sharkNode.size.width
        sharkNode.position = CGPoint(
            x: sharkXPosition,
            y: sharkYPositon)
        
        //setup shark physics
        sharkNode.physicsBody = SKPhysicsBody(rectangleOf: sharkNode.size) // 1
        sharkNode.physicsBody?.isDynamic = true // 2
        sharkNode.physicsBody?.categoryBitMask = PhysicsCategory.shark // 3
        sharkNode.physicsBody?.contactTestBitMask = PhysicsCategory.player // 4
        sharkNode.physicsBody?.collisionBitMask = PhysicsCategory.player // 5
        
        matchManager.addChild(sharkNode)
        
        // add behavior to shark
        let sharkSpeed = random(min: CGFloat(5), max: CGFloat(10))
        let sharkYDestination = random(
            min: matchManager.section2LimitNode.position.y - sharkNode.size.height,
            max: (mapBottomSide + sharkNode.size.height)
        )
        
        // shark movement
        let actionMove = SKAction.move(
            to: CGPoint(
                x: directionRight ? mapRightSide + sharkNode.size.width : mapLeftSide - sharkNode.size.width,
                y: sharkYDestination
            ),
            duration: TimeInterval(sharkSpeed)
        )
        let actionDissapear = SKAction.removeFromParent()
        sharkNode.run(SKAction.sequence([actionMove,actionDissapear]))
        
        // synchronize entity spawn
        let sharkSpawnEvent = MPEntityEvent(event: .sharkSpawn, position: sharkNode.position, entityTextureName: sharkImage, destinationY: sharkYDestination, speed: sharkSpeed, direction: directionRight)
        matchManager.connectionManager.send(entityEvent: sharkSpawnEvent)
    }
    
    func addSharkFromHost(position: CGPoint, entityTextureName: String, destinationY: CGFloat, speed: CGFloat, direction: Bool){
        let sharkImage = entityTextureName
        let directionRight = direction
        let sharkNode = SKSpriteNode(imageNamed: entityTextureName)
        sharkNode.name = "Shark"
        sharkNode.position = position
        
        //setup shark physics
        sharkNode.physicsBody = SKPhysicsBody(rectangleOf: sharkNode.size) // 1
        sharkNode.physicsBody?.isDynamic = true // 2
        sharkNode.physicsBody?.categoryBitMask = PhysicsCategory.shark // 3
        sharkNode.physicsBody?.contactTestBitMask = PhysicsCategory.player // 4
        sharkNode.physicsBody?.collisionBitMask = PhysicsCategory.player // 5
        
        matchManager.addChild(sharkNode)
        
        // add behavior to the shark
        let sharkSpeed = speed
        let sharkYDestination = destinationY
        
        // shark movement
        let actionMove = SKAction.move(
            to: CGPoint(
                x: directionRight ? mapRightSide + sharkNode.size.width : mapLeftSide - sharkNode.size.width,
                y: sharkYDestination
            ),
            duration: TimeInterval(sharkSpeed)
        )
        let actionDissapear = SKAction.removeFromParent()
        sharkNode.run(SKAction.sequence([actionMove,actionDissapear]))
    }
}
