//
//  EndView.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 01/05/24.
//

import SwiftUI

struct EndView: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var matchManager: MatchManager
    
    @State var actionPressed: Bool = false
    @State var userAction: Action = Action.backtomenu
    
    enum Action {
        case backtomenu
        case gotocamera
    }
    
    var body: some View {
        VStack{
            Image(systemName: "trophy.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.yellow)
                .padding(.bottom, 50)
            HStack(alignment: .top) {
                Image("diverDefault")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                .padding(.bottom, 100)
                Rectangle()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(
                        matchManager.winner.id == matchManager.player1Id ? Color.red : Color.blue
                    )
            }
            HStack(spacing: 20) {
                Button(action: {
                    userAction = .backtomenu
                    actionPressed = true
                }, label: {
                    Image(systemName: "gobackward")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .padding()
                })
                .buttonStyle(BorderedProminentButtonStyle())
                
//                Button(action: {
//                    userAction = .gotocamera
//                    actionPressed = true
//                }, label: {
//                    Image(systemName: "camera")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 50, height: 50)
//                        .padding()
//                })
//                .buttonStyle(BorderedButtonStyle())

            }
        }
        .onAppear(){
            actionPressed = false
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $actionPressed) {
            switch userAction {
            case .backtomenu:
                ContentView()
            case .gotocamera:
                ScreenshotView()
            }
        }

        
    }
}

#Preview {
    EndView()
        .environmentObject(MPConnectionManager(playerId: UUID()))
        .environmentObject(MatchManager())
}
