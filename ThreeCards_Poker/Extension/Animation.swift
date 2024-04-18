//
//  Animation.swift
//  ThreeCards_Poker
//
//  Created by MACPC on 12/04/24.
//

import SpriteKit
import UIKit

public func startStrokeAnimationForPlayer(at position: CGPoint, parentNode: SKNode) {
    // Add the profile image for the player
    let profileImage = SKSpriteNode(imageNamed: "user2")
    profileImage.size = CGSize(width: 100, height: 100)
    profileImage.position = position // Adjust position as needed
    parentNode.addChild(profileImage)
    
    // Create stroke node and start animation
    let strokeRadius: CGFloat = 52 // Adjust the radius as needed
    let strokeNode = SKShapeNode(circleOfRadius: strokeRadius)
    strokeNode.position = position
    strokeNode.strokeColor = .yellow // Set stroke color
    strokeNode.lineWidth = 10
    parentNode.addChild(strokeNode)
    
    let drawStrokeAction = SKAction.customAction(withDuration: 10.0) { node, elapsedTime in
        let progress = elapsedTime / 10.0 // Divide by total duration to get progress from 0 to 1
        let angle = CGFloat(progress) * 2 * CGFloat.pi // Convert progress to radians (0 to 2π)
        let path = UIBezierPath(arcCenter: .zero, radius: strokeRadius, startAngle: -CGFloat.pi / 2, endAngle: angle - CGFloat.pi / 2, clockwise: true)
        (node as! SKShapeNode).path = path.cgPath // Update the path of the shape node
    }
    
    strokeNode.run(drawStrokeAction)


}
