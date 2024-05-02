//
//  MultiplayerView.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import SwiftUI

struct MultiplayerLobbyView: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var matchManager: MatchManager
    @State var startGame: Bool = false
    
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                MPPeersView(startGame: $startGame)
                    .environmentObject(connectionManager)
                    .environmentObject(matchManager)
                
                Button(
                    role: .cancel,
                    action: {
                        dismiss()
                        connectionManager.listAvailablePeers.removeAll()
                        connectionManager.stopBrowsing()
                        connectionManager.stopAdvertising()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .frame(maxWidth: .infinity)
                    })
                .buttonStyle(BorderedProminentButtonStyle())
                .tint(Color.red)
            }
            .padding(.horizontal, 30)
            .navigationBarBackButtonHidden(true)
            .onAppear(){
                connectionManager.setupGame(matchManager: matchManager)
            }
        .navigationDestination(
            isPresented: $startGame) {
                GameView()
                    .environmentObject(connectionManager)
                    .environmentObject(matchManager)
            }
        }
    }
}

#Preview {
    MultiplayerLobbyView()
        .environmentObject(
            MPConnectionManager(playerId: UUID()))
        .environmentObject(
            MatchManager()
        )
}
