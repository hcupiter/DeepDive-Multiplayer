//
//  PlayerModel.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import Foundation
import SpriteKit

class PlayerModel: SKSpriteNode, ObservableObject {
    var id: UUID!
    
    func getId() -> UUID {
        if id == nil {
            id = UUID()
        }
        return id
    }
    
}
