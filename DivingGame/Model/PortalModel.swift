//
//  PortalModel.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import Foundation
import SpriteKit

class PortalModel {
    var matchManager: MatchManager
    var portalNode: SKSpriteNode!
    var portalSpawned: Bool = false
    
    init(matchManager: MatchManager){
        self.matchManager = matchManager
        self.portalSpawned = false
    }
    
    func spawnPortal(){
        if portalSpawned {
            return
        }
        
        // Create the portal node
        let portalNode = SKSpriteNode(imageNamed: "Portal 1")
        portalNode.name = "Portal"
        portalNode.size = CGSize(width: 150, height: 250)
        
        portalNode.position = generatePortalPosition(portalNode: portalNode, section3LimitNode: matchManager.section3LimitNode)
        //setup player physics
        portalNode.physicsBody = SKPhysicsBody(rectangleOf: portalNode.size)
        portalNode.physicsBody?.isDynamic = true
        portalNode.physicsBody?.categoryBitMask = PhysicsCategory.portal
        portalNode.physicsBody?.contactTestBitMask = PhysicsCategory.player1 | PhysicsCategory.player2
        portalNode.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        // Create an array to hold SKTexture objects
        var portalTextures: [SKTexture] = []
        
        // Iterate over the array of image names and load them into SKTexture objects
        for imageName in portalImage {
            let texture = SKTexture(imageNamed: imageName)
            portalTextures.append(texture)
        }
        
        // Create an animation action
        let animatePortalAction = SKAction.animate(with: portalTextures, timePerFrame: 0.1)
        
        // Apply the animation to the portal node
        portalNode.run(SKAction.repeatForever(animatePortalAction),withKey: "PortalAnimation")
        self.portalNode = portalNode
        
        // send portal spawned to other person
        let entityEvent = MPEntityEvent(event: .portalSpawn, position: portalNode.position, entityTextureName: nil, destinationY: nil, speed: nil, direction: nil)
        matchManager.connectionManager.send(entityEvent: entityEvent)
        
        matchManager.addChild(portalNode)
        portalSpawned = true
    }
    
    func synchronizePortalSpawnLocation(position: CGPoint){
        if portalSpawned {
            return
        }
        
        // Create the portal node
        let portalNode = SKSpriteNode(imageNamed: "Portal 1")
        portalNode.name = "Portal"
        portalNode.size = CGSize(width: 150, height: 250)
        
        portalNode.position = position
        //setup player physics
        portalNode.physicsBody = SKPhysicsBody(rectangleOf: portalNode.size)
        portalNode.physicsBody?.isDynamic = true
        portalNode.physicsBody?.categoryBitMask = PhysicsCategory.portal
        portalNode.physicsBody?.contactTestBitMask = PhysicsCategory.player1 | PhysicsCategory.player2
        portalNode.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        // Create an array to hold SKTexture objects
        var portalTextures: [SKTexture] = []
        
        // Iterate over the array of image names and load them into SKTexture objects
        for imageName in portalImage {
            let texture = SKTexture(imageNamed: imageName)
            portalTextures.append(texture)
        }
        
        // Create an animation action
        let animatePortalAction = SKAction.animate(with: portalTextures, timePerFrame: 0.1)
        
        // Apply the animation to the portal node
        portalNode.run(SKAction.repeatForever(animatePortalAction),withKey: "PortalAnimation")
        self.portalNode = portalNode
        
        matchManager.addChild(portalNode)
        portalSpawned = true
    }
}
