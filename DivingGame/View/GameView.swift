//
//  GameView.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment (\.dismiss) var dismiss;
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var matchManager: MatchManager
    
    @State private var currentOxygen: CGFloat = 100
    @State private var isGameFinished: Bool = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            SpriteView(scene: matchManager)
                .onReceive(matchManager.$isGameFinish, perform: { _ in
                    if matchManager.isGameFinish == true {
                        isGameFinished = true
                    }
                })
            OxygenBar()
                .environmentObject(connectionManager)
                .environmentObject(matchManager)
                .padding(.trailing, 30)
                .padding(.top, 50)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(){
            matchManager.playerPeerId = connectionManager.myPeerId.displayName
        }
        .onReceive(connectionManager.$paired, perform: { _ in
            if connectionManager.paired == false {
                dismiss()
            }
        })
        .navigationDestination(isPresented: $isGameFinished) {
            EmptyView()
                .navigationBarBackButtonHidden(true)
        }
        
    }
}

#Preview {
    GameView()
        .environmentObject(MPConnectionManager(playerId: UUID()))
        .environmentObject(MatchManager())
}
