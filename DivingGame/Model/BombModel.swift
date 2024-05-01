//
//  BombModel.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import Foundation
import SpriteKit

class BombModel {
    var matchManager: MatchManager
    var allBombSpawned: Bool
    var bombSpawnedCount: Int
    
    init(matchManager: MatchManager) {
        self.matchManager = matchManager
        allBombSpawned = false
        bombSpawnedCount = 0
    }
    
    func spawnBomb(){
        if allBombSpawned == false && bombSpawnedCount <= 30 && matchManager.portal.portalNode != nil {
            let bombNode = SKSpriteNode(imageNamed: bomb)
            bombNode.name = "Bomb"
            
            let bombYPosition = random(
                min: matchManager.section3LimitNode.position.y - bombNode.size.height,
                max: mapBottomSide + bombNode.size.height)
            
            let bombXPosition  = random(
                min: mapLeftSide + bombNode.size.width,
                max: mapRightSide - bombNode.size.width)
            
            bombNode.position = CGPoint(
                x : bombXPosition,
                y : bombYPosition)
            
            while(isInPortalFrame(portalNode: matchManager.portal.portalNode, objectNode: bombNode)){
                let bombYPosition = random(
                    min: matchManager.section3LimitNode.position.y - bombNode.size.height,
                    max: mapBottomSide + bombNode.size.height)
                
                let bombXPosition  = random(
                    min: mapLeftSide + bombNode.size.width,
                    max: mapRightSide - bombNode.size.width)
                
                bombNode.position = CGPoint(
                    x : bombXPosition,
                    y : bombYPosition)
            }
            
            //setup player physics
            bombNode.physicsBody = SKPhysicsBody(rectangleOf: bombNode.size)
            bombNode.physicsBody?.isDynamic = true
            bombNode.physicsBody?.categoryBitMask = PhysicsCategory.bomb
            bombNode.physicsBody?.contactTestBitMask = PhysicsCategory.player1 | PhysicsCategory.player2
            bombNode.physicsBody?.collisionBitMask = PhysicsCategory.none
            
            bombSpawnedCount += 1
            matchManager.addChild(bombNode)
            
            // send placed bomb to another device
            let bombSpawnEvent = MPEntityEvent(event: .bombSpawn, position: bombNode.position, entityTextureName: nil, destinationY: nil, speed: nil, direction: nil)
            matchManager.connectionManager.send(entityEvent: bombSpawnEvent)
            
            if bombSpawnedCount >= 30 {
                allBombSpawned = true
            }
        }
    }
    
    func synchronizeBombPlacingWithHost(position: CGPoint){
        let bombNode = SKSpriteNode(imageNamed: bomb)
        bombNode.name = "Bomb"
        bombNode.position = position
        
        //setup player physics
        bombNode.physicsBody = SKPhysicsBody(rectangleOf: bombNode.size)
        bombNode.physicsBody?.isDynamic = true
        bombNode.physicsBody?.categoryBitMask = PhysicsCategory.bomb
        bombNode.physicsBody?.contactTestBitMask = PhysicsCategory.player1 | PhysicsCategory.player2
        bombNode.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        matchManager.addChild(bombNode)
    }
}
