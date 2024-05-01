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
        VStack(alignment: .leading, content: {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding()
                .foregroundStyle(Color.blue)
            List(connectionManager.listAvailablePeers, id: \.self){ peer in
                HStack {
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
                            Image("diverDefault")
                                .resizable()
                                .frame(width: 50, height: 50)
                            .aspectRatio(contentMode: .fill)
                            Spacer()
                            Image(systemName: "gamecontroller.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fill)
                            }
                        .listRowInsets(EdgeInsets())
                    })
                    .buttonStyle(BorderedButtonStyle())
                }
                .listStyle(.plain)
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
            connectionManager.startAdvertising()
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
