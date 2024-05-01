//
//  MPPeersView.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import SwiftUI
import MultipeerConnectivity

struct MPPeersView: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var matchManager: MatchManager
    @Binding var startGame: Bool
    
    var body: some View {
        VStack(content: {
            Image(systemName: "magnifyingglass")
            List(connectionManager.listAvailablePeers, id: \.self){ peer in
                Button(action: {
                    connectionManager.nearbyServiceBrowser.invitePeer(
                        peer, 
                        to: connectionManager.session,
                        withContext: nil,
                        timeout: 30
                    )
                    matchManager.player1 = connectionManager.myPeerId.displayName
                    matchManager.player2 = peer.displayName
                }, label: {
                    HStack {
                        Image(systemName: "person")
                        Text(peer.displayName)
                    }
                })
                .alert("Received invitation from \(connectionManager.receivedInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManager.receivedInvite) {
                    Button("Reject") {
                        if let invitationHandler = connectionManager.invitationHandler {
                            invitationHandler(false, nil)
                        }
                    }
                    .foregroundStyle(Color.red)
                    .tint(Color.red)
                    
                    Button("Accept") {
                        if let invitationHandler = connectionManager.invitationHandler {
                            invitationHandler(true, connectionManager.session)
                            matchManager.player1 = connectionManager.receivedInviteFrom?.displayName ?? "Unknown"
                            matchManager.player2 = connectionManager.myPeerId.displayName
                        }
                    }
                }
            }
        })
        .onAppear(){
            connectionManager.isAvailableToPlay = true
            connectionManager.startBrowsing()
        }
        .onDisappear(){
            connectionManager.isAvailableToPlay = false
            connectionManager.stopBrowsing()
            connectionManager.stopAdvertising()
        }
        .onChange(of: connectionManager.paired) { oldValue, newValue in
            startGame = newValue
        }
    }
}

#Preview {
    MPPeersView(startGame: .constant(false))
        .environmentObject(MPConnectionManager(playerId: UUID()))
        .environmentObject(MatchManager())
}
