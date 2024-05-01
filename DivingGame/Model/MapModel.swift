//
//  MapModel.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 01/05/24.
//

import Foundation
import SpriteKit

class MapModel {
    var mapNode: SKSpriteNode
    var initLocation: CGPoint!
    var matchManager: MatchManager
    
    init(matchManager: MatchManager){
        self.matchManager = matchManager
        mapNode = SKSpriteNode(texture: SKTexture(imageNamed: "Map"))
        mapNode.position = CGPoint(x: 0, y: 0)
        
        // init Starting Location
        initLocation = CGPoint(x: 0, y: mapNode.position.y + (mapNode.size.height/2) - (mapNode.size.height * 0.1) + 100)
    }
    
    func checkIfPlayerInZone1(player: PlayerModel) -> Bool{
        if player.playerNode.position.y > matchManager.section2LimitNode.position.y {
            return true
        }
        return false
    }
    
    func checkIfPlayerInZone2(player: PlayerModel) -> Bool {
        if player.playerNode.position.y <= matchManager.section2LimitNode.position.y 
            && player.playerNode.position.y > matchManager.section3LimitNode.position.y {
            return true
        }
        return false
    }
    
    func checkIfPlayerInZone3(player: PlayerModel) -> Bool {
        if player.playerNode.position.y <= matchManager.section3LimitNode.position.y {
            return true
        }
        return false
    }
    
}
