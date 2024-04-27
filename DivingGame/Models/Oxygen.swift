//
//  Oxygen.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 27/04/24.
//

import Foundation

class Oxygen: ObservableObject {
    @Published var oxygenLevel: CGFloat = 100
    var maxOxygenLevel: CGFloat
    
    init(){
        maxOxygenLevel = 100
    }
    
    func updateOxygen() {
        oxygenLevel -= 1
    }
}
