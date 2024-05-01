//
//  ContentView.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 25/04/24.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var connectionManager: MPConnectionManager
    @StateObject var matchManager: MatchManager
    
    @State var selectedMode: mode = mode.singleplayer
    @State var userHasSelectMode: Bool = false
    
    init(){
        _connectionManager = StateObject(
            wrappedValue: MPConnectionManager(
                playerId: UUID()
            )
        )
        _matchManager = StateObject(
            wrappedValue: MatchManager(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        )
    }
    
    enum mode {
        case singleplayer
        case multiplayer
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, content: {
                Text("Deep Dive")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Choose Play Mode")
                
                Button(action: {
                    selectedMode = mode.singleplayer
                    userHasSelectMode = true
                }, label: {
                    Label("Singleplayer", systemImage: "person")
                })
                .buttonStyle(BorderedProminentButtonStyle())
                .disabled(true)
                
                Button(action: {
                    selectedMode = mode.multiplayer
                    userHasSelectMode = true
                }, label: {
                    Label("Multiplayer", systemImage: "person")
                })
                .buttonStyle(BorderedProminentButtonStyle())
                .foregroundStyle(Color.white)
                .tint(Color.green)
                
            })
            .navigationDestination(isPresented: $userHasSelectMode) {
                switch selectedMode {
                case .singleplayer:
                    EmptyView()
                case .multiplayer:
                    MultiplayerLobbyView()
                        .environmentObject(connectionManager)
                        .environmentObject(matchManager)
                        .onAppear(){
                            connectionManager.listAvailablePeers = []
                        }
                }
            }
        }
        
    }
    
    
}

#Preview {
    ContentView()
}
