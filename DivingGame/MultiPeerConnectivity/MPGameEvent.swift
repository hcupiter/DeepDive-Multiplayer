//
//  MPGameMove.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import Foundation

struct MPGameEvent: Codable {
    enum Event: String, Codable {
        case start
        case move
        case hit
        case death
        case reset
        case end
    }
    
    let action: Event
    let playerId: String
    let playerPosition: CGPoint
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
