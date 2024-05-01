//
//  GameView.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var matchManager: MatchManager
    
    var body: some View {
        VStack {
            SpriteView(scene: matchManager)
//                .onReceive(gameScene.$currentOxygenLevel, perform: { _ in
//                    currentOxygen = gameScene.currentOxygenLevel
//                })
//                .onReceive(gameScene.$gameFinish, perform: { _ in
//                    isGameFinished = true
//                })
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(){
            matchManager.playerPeerId = connectionManager.myPeerId.displayName
        }
        
    }
}

#Preview {
    GameView()
        .environmentObject(MPConnectionManager(playerId: UUID()))
        .environmentObject(MatchManager())
}
