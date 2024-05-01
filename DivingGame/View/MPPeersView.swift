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
                    matchManager.player1Id = connectionManager.myPeerId.displayName
                    matchManager.player2Id = peer.displayName
                }, label: {
                    HStack {
                        Image(systemName: "person")
                        Text(peer.displayName)
                    }
                })
                .alert("Received invitation from \(connectionManager.receivedInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManager.receivedInvite) {
                    Button(action: {
                        if let invitationHandler = connectionManager.invitationHandler {
                            invitationHandler(false, nil)
                        }
                    }, label: {
                        Text("Reject")
                    })
                    .foregroundStyle(Color.red)
                    .tint(Color.red)
                    
                    Button(action: {
                        if let invitationHandler = connectionManager.invitationHandler {
                            invitationHandler(true, connectionManager.session)
                            matchManager.player1Id = connectionManager.receivedInviteFrom?.displayName ?? "Unknown"
                            matchManager.player2Id = connectionManager.myPeerId.displayName
                        }
                    }, label: {
                        Text("Accept")
                    })
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
