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
    
    @State var userClickedPlay: Bool = false
    
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
                Image("diverDefault")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                .padding(.bottom, 40)
                
                Button(action: {
                    userClickedPlay = true
                }, label: {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .padding()
                })
                .buttonStyle(BorderedProminentButtonStyle())
            })
            .onAppear(){
                userClickedPlay = false
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $userClickedPlay) {
                MultiplayerLobbyView()
                    .environmentObject(connectionManager)
                    .environmentObject(matchManager)
            }
        }
        
    }
    
    
}

#Preview {
    ContentView()
}
