//
//  Utility.swift
//  DeepDive
//
//  Created by Andrew Oroh on 27/04/24.
//

import Foundation
import SpriteKit

func getRandomString() -> String {
    let strings = [sharkRight1, sharkRight2, sharkLeft]
    let randomIndex = Int.random(in: 0..<strings.count)
    return strings[randomIndex]
}

func random() -> CGFloat {
  return CGFloat(Double(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
  return random() * (max - min) + min
}

func generatePortalPosition(portalNode : SKSpriteNode, section3LimitNode : SKSpriteNode) -> CGPoint{
    let portalYPosition = random(
        min: section3LimitNode.position.y - portalNode.size.height,
        max: mapBottomSide + portalNode.size.height)
    
    let portalXPosition  = random(
        min: mapLeftSide + portalNode.size.width,
        max: mapRightSide - portalNode.size.width)
    
    return CGPoint(x: portalXPosition, y: portalYPosition)
    
}

func isInPortalFrame(portalNode : SKSpriteNode, objectNode : SKSpriteNode) -> Bool{
//    print("portal minX : \(abs(portalNode.frame.minX))")
//    print("portal maxX : \(abs(portalNode.frame.maxX))")
//    print("portal minY : \(abs(portalNode.frame.minY))")
//    print("portal minY : \(abs(portalNode.frame.maxY))")
//
//    print("portal position x : \(portalNode.position.x)")
//    print("portal position x : \(portalNode.position.y)")
//
//    print("portal size : \(portalNode.size)\n\n")
//
//    print("bomb : \(bombNode.position)")
    if (( abs(objectNode.position.x) >= (abs(portalNode.frame.minX) - portalNode.frame.width) && abs(objectNode.position.x) <= (abs(portalNode.frame.maxX)) + portalNode.frame.width) && ( abs(objectNode.position.y) >= (abs(portalNode.frame.minY) - portalNode.frame.height) && abs(objectNode.position.y) <= (abs(portalNode.frame.maxY)) + portalNode.frame.height)){
        return true
    }
    return false
}

//func isPlayerAtTheMiddleOfThePortal(portalNode : SKSpriteNode, objectNode : SKSpriteNode) -> Bool{
//    if objectNode.position == portalNode.position {
//        return true
//    }
//    return false
//}

//func isPlayerAtTheMiddleOfThePortal(portalNode : SKSpriteNode, objectNode : SKSpriteNode) -> Bool{
//    let widthHitBoxConstant: CGFloat = 100
//    let heightHitBoxConstant: CGFloat = 300
//    if (( abs(objectNode.position.x) >= (abs(portalNode.frame.minX) - widthHitBoxConstant) && abs(objectNode.position.x) <= (abs(portalNode.frame.maxX)) + widthHitBoxConstant) && ( abs(objectNode.position.y) >= (abs(portalNode.frame.minY) - heightHitBoxConstant) && abs(objectNode.position.y) <= (abs(portalNode.frame.maxY)) + heightHitBoxConstant)){
//        return true
//    }
//    return false
//}
