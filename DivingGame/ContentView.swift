//
//  ContentView.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 25/04/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gyro = GyroManager.shared
    @State private var curr: Double = 0
    @State private var gyroInfo: String = "Inactive"
    
    var body: some View {
        VStack {
            Text("Gyro Status: \(gyroInfo)")
        }
        .onAppear(){
            curr = gyro.x
        }
    }
    
    func checkSideMove(){
        if curr < gyro.x {
            gyroInfo = "Left"
        } else {
            gyroInfo = "Right"
        }
    }
}

#Preview {
    ContentView()
}
