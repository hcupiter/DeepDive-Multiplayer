//
//  Tools.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 01/05/24.
//

import Foundation
import SpriteKit

func generatePortalPosition(portalNode : SKSpriteNode, section3LimitNode : SKSpriteNode) -> CGPoint{
    let portalYPosition = random(
        min: section3LimitNode.position.y - portalNode.size.height,
        max: mapBottomSide + portalNode.size.height)
    
    let portalXPosition  = random(
        min: mapLeftSide + portalNode.size.width,
        max: mapRightSide - portalNode.size.width)
    
    return CGPoint(x: portalXPosition, y: portalYPosition)
}

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

func isInPortalFrame(portalNode: SKSpriteNode, objectNode: SKSpriteNode) -> Bool {
    let portalFrame = portalNode.frame.insetBy(dx: 150, dy: 150)
    let objectFrame = objectNode.frame

    return portalFrame.contains(objectFrame)
}
