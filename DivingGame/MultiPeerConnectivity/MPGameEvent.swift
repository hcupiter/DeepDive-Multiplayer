//
//  MPGameMove.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import Foundation
import SpriteKit

struct MPPlayerEvent: Codable {
    enum Action: String, Codable {
        case start
        case move
        case hit
        case death
        case reset
        case end
        case reachPortal
    }
    
    let action: Action
    let playerId: String
    let playerPosition: CGPoint
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}

struct MPEntityEvent: Codable {
    enum EntityEvent: String, Codable {
        case sharkSpawn
        case bombSpawn
        case portalSpawn
    }
    
    let event: EntityEvent
    let position: CGPoint
    let entityTextureName: String!
    let destinationY: CGFloat!
    let speed: CGFloat!
    let direction: Bool!
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
}
