//
//  Misc.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import Foundation
import SpriteKit

// map limit
let mapLeftSide = -1152.0
let mapRightSide = 1152.0
let mapTopSide = 2048.0
let mapBottomSide = -2048.0

// map divider
let section1 = 0
let section2 = 680
let section3 = -684

// shark images
let sharkRight1 = "Shark Right 1"
let sharkRight2 = "Shark Right 2"
let sharkLeft = "Shark Left"
let bomb = "Bomb"

let portalImage = ["Portal 1","Portal 2", "Portal 3", "Portal 4", "Portal 5", "Portal 6", "Portal 7","Portal 8", "Portal 9"]

struct PhysicsCategory {
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let player1 : UInt32 = 0b1
    static let player2: UInt32 = 0b10
    static let shark : UInt32 = 0b100
    static let bomb: UInt32 = 0b1000
    static let portal: UInt32 = 0b10000
}




