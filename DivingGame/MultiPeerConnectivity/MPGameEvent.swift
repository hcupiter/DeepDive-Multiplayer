//
//  MPGameMove.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import Foundation

struct MPGameEvent: Codable {
    enum Event: String, Codable {
        case start, move, hit, death, reset, end
    }
    
    let action: Event
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
