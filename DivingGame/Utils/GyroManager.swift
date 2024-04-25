//
//  GyroManager.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 25/04/24.
//

import Foundation
import CoreMotion

class GyroManager: ObservableObject {
    private let manager = CMMotionManager()
    @Published var x = 0.0
    
    private init(){
        manager.deviceMotionUpdateInterval = 1/15
        
        manager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
            guard let motion = data?.attitude else {
                return
            }
            
            self?.x = motion.roll
        }
    }
    
    static let shared = GyroManager()
}
