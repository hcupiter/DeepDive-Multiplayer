//
//  GameView.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var matchManager: MatchManager
    
    var body: some View {
        VStack {
            Text("player1: \(matchManager.player1)")
            Text("player2: \(matchManager.player2)")
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    GameView()
        .environmentObject(MPConnectionManager(playerId: UUID()))
        .environmentObject(MatchManager())
}
