//
//  ContentView.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 25/04/24.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject private var gyro = GyroManager.shared
    @State private var curr: Double = 0
    @State private var gyroInfo: String = "Inactive"
    @State private var isButtonPressed: Bool = false
    
    var scene: GameScene
    init(){
        scene = GameScene()
        scene.scaleMode = .fill
    }
    
    var body: some View {
        VStack {
            Text("Gyro Status: \(gyroInfo)  \(gyro.x) \(gyro.y)")
            SpriteView(scene: scene)
            
//            VStack {
//                ControlButton(iconName: "arrowshape.up.fill")
//                    .onTapGesture {
//                        self.movePlayerUp()
//                    }
//
//                ControlButton(iconName: "arrowshape.down.fill")
//                    .onTapGesture {
//                        self.movePlayerDown()
//                        
//                    }
//            }
        }
//        .onReceive(gyro.$x, perform: { x in
//            checkSideMove()
//            scene.movePlayer(dx: x, dy: gyro.y)
//        })
//        .onReceive(gyro.$y, perform: { y in
//            scene.movePlayer(dx: gyro.x, dy: y)
//        })
        .onChange(of: [gyro.x, gyro.y]) {
            checkSideMove()
            scene.movePlayer(dx: gyro.x, dy: gyro.y)
        }
    }
    
    func checkSideMove(){
        if gyro.x < 0{
            gyroInfo = "Left"
        } else {
            gyroInfo = "Right"
        }
        curr = gyro.x
    }
    
//    func movePlayerDown(){
//        isButtonPressed = true
//        scene.movePlayerDown()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.isButtonPressed = false
//        }
//    }
//    
//    func movePlayerUp(){
//        isButtonPressed = true
//        scene.movePlayerUp()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.isButtonPressed = false
//        }
//    }
}

#Preview {
    ContentView()
}
