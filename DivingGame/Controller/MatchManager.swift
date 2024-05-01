//
//  MatchManager.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import Foundation
import SpriteKit
import MultipeerConnectivity


class MatchManager: ObservableObject{    
    @Published var inGame: Bool = false
    @Published var isGameOver: Bool = false
    
    @Published var sharkList: [SharkModel] = []
    @Published var bombList: [BombModel] = []
    @Published var portal: PortalModel!
    
    @Published var player1: String = ""
    @Published var player2: String = ""
    
    // function to handle game event
    func handleEvent(gameEvent: MPGameEvent, mpConnectionManager: MPConnectionManager) {
        switch gameEvent.action {
        case .start:
            print("Start")
        case .move:
            print("Move")
        case .reset:
            print("Reset")
        case .end:
            player1 = ""
            player2 = ""
            mpConnectionManager.session.disconnect()
        }
    }
}

