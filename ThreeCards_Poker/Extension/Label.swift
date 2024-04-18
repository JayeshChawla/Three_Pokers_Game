//
//  Labe.swift
//  ThreeCards_Poker
//
//  Created by MACPC on 12/04/24.
//

import Foundation
import SpriteKit

class PackLabelNode : SKLabelNode{
    
    init(text : String , postion : CGPoint , duration : TimeInterval){
        super.init()
        
        self.text = text
        self.fontName = "Helevetica-Bold"
        self.fontSize = 24
        self.fontColor = .white
        self.position = postion
        self.zPosition = 10
        
        let removeAction = SKAction.sequence([SKAction.wait(forDuration: duration), SKAction.removeFromParent()])
        self.run(removeAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
