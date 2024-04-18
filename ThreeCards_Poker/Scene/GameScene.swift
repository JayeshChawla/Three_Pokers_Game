//
//  GameScene.swift
//  ThreeCards_Poker
//
//  Created by MACPC on 08/04/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    var strokeNodeTopLeft: SKShapeNode?
    var strokeNodeTopRight: SKShapeNode?
    var strokeNodeBottomLeft: SKShapeNode?
    var strokeNodeBottomRight: SKShapeNode?
    
    var cardsDistributed = false
    
    var cardsForPlayerTopLeft: [SKSpriteNode] {
        return cards.filter { $0.position.x <= playableRect.midX && $0.position.y > playableRect.midY }
    }

    var cardsForPlayerTopRight: [SKSpriteNode] {
        return cards.filter { $0.position.x > playableRect.midX && $0.position.y > playableRect.midY }
    }

    var cardsForPlayerBottomLeft: [SKSpriteNode] {
        return cards.filter { $0.position.x <= playableRect.midX && $0.position.y <= playableRect.midY }
    }

    var cardsForPlayerBottomRight: [SKSpriteNode] {
        return cards.filter { $0.position.x > playableRect.midX && $0.position.y <= playableRect.midY }
    }

    var playableRect : CGRect{
        let ratio : CGFloat
        switch UIScreen.main.nativeBounds.height{
        case 2688 , 1792 , 2436 : ratio = 2.16
        default : ratio = 16/9
        }
        let width = size.width
        let height = width / ratio
        let x : CGFloat = 0.0
        let y : CGFloat = (size.height - height)/2
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    var cards: [SKSpriteNode] = []
    
    let cardBackTexture = SKTexture(imageNamed: "cards")
    let cardFrontTextures: [SKTexture] = {
          var textures = [SKTexture]()
          for suit in CardSuit.allValues {
              for rank in 1...13 {
                  let texture = SKTexture(imageNamed: "\(suit.rawValue)\(rank)")
                  textures.append(texture)
              }
          }
          return textures
      }()
    
    override func didMove(to view: SKView) {
       setupNode()
 
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        // Check if the touch is on the middle deck of setup cards
        if playableRect.contains(touchLocation) && !cardsDistributed {
            distributeCards()
            cardsDistributed = true
        } else {
            // Top-left quadrant
            if touchLocation.x <= playableRect.midX && touchLocation.y > playableRect.midY {
                flipCards(cardsForPlayerTopLeft)
            }
            // Top-right quadrant
            else if touchLocation.x > playableRect.midX && touchLocation.y > playableRect.midY {
                flipCards(cardsForPlayerTopRight)
            }
            // Bottom-left quadrant
            else if touchLocation.x <= playableRect.midX && touchLocation.y <= playableRect.midY {
                flipCards(cardsForPlayerBottomLeft)
            }
            // Bottom-right quadrant
            else if touchLocation.x > playableRect.midX && touchLocation.y <= playableRect.midY {
                flipCards(cardsForPlayerBottomRight)
            }
        }
   
        
        let touchAreaInset: CGFloat = 50 // Increase this value to define a larger touch area
        
//        CGPoint(x: playableRect.maxX - 280, y: playableRect.maxY - 180)
        if touchLocation.x >= playableRect.maxX - 280 - touchAreaInset &&
           touchLocation.x <= playableRect.maxX - 280 + 100 + touchAreaInset &&
           touchLocation.y >= playableRect.minY + 180 - touchAreaInset &&
           touchLocation.y <= playableRect.minY + 180 + 100 + touchAreaInset {
            // Handle the tap on the profile image for the bottom-right player
            handleTapOnBottomRightPlayer()
        }
        
//    x: playableRect.maxX - 280, y: playableRect.minY + 180)
        if touchLocation.x >= playableRect.maxX - 280 - touchAreaInset &&
           touchLocation.x <= playableRect.maxX - 180 + touchAreaInset &&
           touchLocation.y >= playableRect.maxY - 280 - touchAreaInset &&
           touchLocation.y <= playableRect.maxY - 180 + touchAreaInset {
            // Handle the tap on the profile image for the top-right player
            handleTapOnTopRightPlayer()
        }
    }

}



extension GameScene{
    func setupNode(){
    
        
        let backgroundImage = SKSpriteNode(imageNamed: "table")
        backgroundImage.size = playableRect.size
        backgroundImage.position = CGPoint(x: playableRect.midX, y: playableRect.midY)
        backgroundImage.zPosition = -1
        addChild(backgroundImage)
        
        
        
        
        setupTable()
        drawPlayablearea()
        
        let personImage = Image.createImageNode(imageNamed: "person", size: CGSize(width: 100, height: 100), postion: CGPoint(x: playableRect.midX, y: playableRect.maxY - 130))
          addChild(personImage)
    
        // Add image at the right side after 5 seconds
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               let rightImage = Image.createImageNode(imageNamed: "Hi", size: CGSize(width: 200, height: 180), postion: CGPoint(x: personImage.position.x + 130, y: personImage.position.y))
               self.addChild(rightImage)
               DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                   rightImage.removeFromParent()
               }
               
               // Add another image after 5 seconds
               DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                   let nextImage = Image.createImageNode(imageNamed: "lets", size: CGSize(width: 200, height: 180), postion: CGPoint(x: personImage.position.x + 130, y: personImage.position.y))
                   self.addChild(nextImage)
                   // Remove the next image after 5 seconds
                   DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                       nextImage.removeFromParent()
                   }
               }
               
               // Remove the right image after 5 seconds
               DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                   rightImage.removeFromParent()
               }
           }
        
        
    }
    func drawPlayablearea(){
        let shape = SKShapeNode(rect: playableRect)
        shape.strokeColor = .red
        shape.lineWidth = 5.0
        addChild(shape)
    }
    func setupTable() {
        let cardWidth: CGFloat = 85
        let cardHeight: CGFloat = 125
        let gapBetweenCards: CGFloat = 20
        let totalCardWidth = CGFloat(CardSuit.allValues.count) * cardWidth + CGFloat(CardSuit.allValues.count - 1) * gapBetweenCards
        let startX = (playableRect.width - totalCardWidth) / 2
        let initialY = size.height / 2
        
        for (index, suit) in CardSuit.allValues.enumerated() {
            for rank in 1...10 { // Assuming ranks from 1 to 13
                let card = SKSpriteNode(imageNamed: "\(CardSuit.allValues)\(rank)")
                card.size = CGSize(width: cardWidth, height: cardHeight)
                card.position = CGPoint(x: size.width / 2, y: initialY + CGFloat(index) * 10) // Adjust the y position
                addChild(card)
                cards.append(card)
            }
        }
    }

    func distributeCards() {
        let personImage = Image.createImageNode(imageNamed: "person", size: CGSize(width: 100, height: 100), postion: CGPoint(x: playableRect.midX, y: playableRect.maxY - 130))
        // Assuming 'cardBackTexture' is the SKTexture for the back of your cards
        let cardBackTexture = SKTexture(imageNamed: "cards")

        // Shuffle the cards to ensure random distribution
        cards.shuffle()

        // This loop now only iterates through the first 12 shuffled cards (3 for each of the 4 players)
        for i in 0..<12 {
            let card = cards[i]
            // Set each card to show its back
            card.texture = cardBackTexture
            
            let destination: CGPoint
            let playerIndex = i % 4
            var xOffset: CGFloat = CGFloat(i / 4) * 60
            
            // Calculate the destination based on the player index
            // Adjust the x and y to make the cards appear close to each player
            switch playerIndex {
                  case 0: // Top left player
                      destination = CGPoint(x: playableRect.minX + card.size.width * 5 + xOffset, y: playableRect.maxY - card.size.height * 2)
                  case 1: // Top right player
                      destination = CGPoint(x: playableRect.maxX - card.size.width * 5 - xOffset, y: playableRect.maxY - card.size.height * 2)
                  case 2: // Bottom left player
                      destination = CGPoint(x: playableRect.minX + card.size.width * 5 + xOffset, y: playableRect.minY + card.size.height * 2)
                  case 3: // Bottom right player
                      destination = CGPoint(x: playableRect.maxX - card.size.width * 5 - xOffset, y: playableRect.minY + card.size.height * 2)
                  default:
                      destination = CGPoint.zero // Fallback, should not happen
                  }
            
            
            // Add profile image at the left side of the destination
            
            // Create a move action to the calculated destination
            let moveAction = SKAction.move(to: destination, duration: 0.5)
            // Optionally, add a delay based on 'i' to stagger the dealing animation
            let delayAction = SKAction.wait(forDuration: 0.1 * Double(i))
            // Sequence the delay and move actions
            let sequenceAction = SKAction.sequence([delayAction, moveAction])
            
            let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: 0.5)
            let rotateSequence = SKAction.sequence([delayAction, rotateAction])
            let groupAction = SKAction.group([sequenceAction, rotateSequence])

            card.run(groupAction)
        }
        

        // Hide the remaining cards in the middle
        let hideAction = SKAction.run {
            for i in 12..<self.cards.count{
                self.cards[i].isHidden = true
            }
        }
        let waitAction = SKAction.wait(forDuration: 2.0)
        
        let showImage = SKAction.run {
//            Add the Image
            let imagenode = SKSpriteNode(imageNamed: "play")
            imagenode.position = CGPoint(x: self.playableRect.midX, y: self.playableRect.midY)
//            imagenode.setScale(0)
//            let scaleupAction = SKAction.scale(by: 1.0, duration: 0.5)
//            imagenode.run(scaleupAction)
            self.addChild(imagenode)
            
            let showAction = SKAction.wait(forDuration: 2.0)
            let removeAction = SKAction.removeFromParent()
            let sequenceAction = SKAction.sequence([showAction , removeAction])
            imagenode.run(sequenceAction)
        }
        let sequenceAction = SKAction.sequence([waitAction , hideAction , showImage])
        run(sequenceAction)
        
        addProfileImage()
        addProfileImagebottomRight()
        addProfileImageTopRight()
        addProfileImageTopLeft()
        
        let buttonYPosition = self.playableRect.minY + 120

        var seeButton : ButtonScene = {
            var button = ButtonScene(imageNamed: "button" , tittle: "See") {
                self.flipBottomLeftPlayerCards()
            }
            
            button.position = CGPoint(x: self.playableRect.midX - 330, y: buttonYPosition)
            button.zPosition = 1
            return button
           
        }()
        var blindButton : ButtonScene = {
            var button = ButtonScene(imageNamed: "button" ,tittle: "Blind") {
                let blindImage = Image.createImageNode(imageNamed: "blind1", size: CGSize(width: 200, height: 180), postion: CGPoint(x: personImage.position.x + 140 , y: personImage.position.y))
                self.addChild(blindImage)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    blindImage.removeFromParent()
                }
                self.strokeNodeTopLeft?.removeFromParent()
            }
            
            button.position = CGPoint(x: self.playableRect.midX - 190, y: buttonYPosition)
            button.zPosition = 1
            return button
           
        }()
        var packButton : ButtonScene = {
            var button = ButtonScene(imageNamed: "button" , tittle: "Pack") {
                let packImage = Image.createImageNode(imageNamed: "pack1", size: CGSize(width: 200, height: 180), postion: CGPoint(x: personImage.position.x + 140, y: personImage.position.y))
                self.addChild(packImage)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    packImage.removeFromParent()
                }
                self.strokeNodeTopLeft?.removeFromParent()
                self.startStrokeAnimationForBottomRightPlayer()
            }
            
            button.position = CGPoint(x: self.playableRect.midX - 50, y: buttonYPosition)
            button.zPosition = 1
            return button
           
        }()
        
        addChild(seeButton)
        addChild(blindButton)
        addChild(packButton)
        
    }
    func startStrokeAnimationForBottomRightPlayer() {
        // Add the profile image for bottom right player
        let profileImage = SKSpriteNode(imageNamed: "user2")
        profileImage.size = CGSize(width: 100, height: 100)
        profileImage.position = CGPoint(x: playableRect.maxX - 280, y: playableRect.minY + 180) // Adjust position as needed
        addChild(profileImage)
        
        // Create stroke node and start animation
        let strokeRadius: CGFloat = 52 // Adjust the radius as needed
        let strokeNode = SKShapeNode(circleOfRadius: strokeRadius)
        strokeNode.position = profileImage.position
        strokeNode.strokeColor = .yellow // Set stroke color
        strokeNode.lineWidth = 10
        addChild(strokeNode)
        
        self.strokeNodeBottomRight = strokeNode // Assign to the class variable
        
        let drawStrokeAction = SKAction.customAction(withDuration: 10.0) { node, elapsedTime in
            let progress = elapsedTime / 10.0 // Divide by total duration to get progress from 0 to 1
            let angle = CGFloat(progress) * 2 * CGFloat.pi // Convert progress to radians (0 to 2π)
            let path = UIBezierPath(arcCenter: .zero, radius: strokeRadius, startAngle: -CGFloat.pi / 2, endAngle: angle - CGFloat.pi / 2, clockwise: true)
            (node as! SKShapeNode).path = path.cgPath // Update the path of the shape node
        }
        
        strokeNode.run(drawStrokeAction)
    }
    
    


    func flipCard(_ card: SKSpriteNode) {
            let flipDuration: TimeInterval = 0.5
            let flipOutAction = SKAction.scaleX(to: 0.0, duration: flipDuration / 2)
            let changeTextureAction = SKAction.run {
                if let currentTexture = card.texture, let index = self.cardFrontTextures.firstIndex(of: currentTexture) {
                    let newTexture = self.cardBackTexture
                    card.texture = newTexture
                } else {
                    let newTexture = self.cardFrontTextures.randomElement() ?? self.cardBackTexture
                    card.texture = newTexture
                }
            }
            let flipInAction = SKAction.scaleX(to: 1.0, duration: flipDuration / 2)
            let flipSequence = SKAction.sequence([flipOutAction, changeTextureAction, flipInAction])
            card.run(flipSequence)
        }
    
    // Function to flip all three cards for a player
    func flipCards(_ cards: [SKSpriteNode]) {
        for card in cards {
            flipCard(card)
        }
    }
    func flipBottomLeftPlayerCards() {
        flipCards(cardsForPlayerBottomLeft)
    }
    
    
    
    func addProfileImage() {
        // Add profile image
        let profileImage = SKSpriteNode(imageNamed: "user2")
        profileImage.size = CGSize(width: 100, height: 100)
        profileImage.position = CGPoint(x: playableRect.minX + 280, y: playableRect.minY + 180) // Adjust position as needed
        addChild(profileImage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            let strokeRadius: CGFloat = 52 // Adjust the radius as needed
            let strokeNode = SKShapeNode(circleOfRadius: strokeRadius)
            strokeNode.position = profileImage.position
            strokeNode.strokeColor = .yellow // Set stroke color
            strokeNode.lineWidth = 10
            self.addChild(strokeNode)
            
            self.strokeNodeTopLeft = strokeNode
            
            // Animate the drawing of the stroke
            let drawStrokeAction = SKAction.customAction(withDuration: 10.0) { node, elapsedTime in
                let progress = elapsedTime / 10.0 // Divide by total duration to get progress from 0 to 1
                let angle = CGFloat(progress) * 2 * CGFloat.pi // Convert progress to radians (0 to 2π)
                let path = UIBezierPath(arcCenter: .zero, radius: strokeRadius, startAngle: -CGFloat.pi / 2, endAngle: angle - CGFloat.pi / 2, clockwise: true)
                (node as! SKShapeNode).path = path.cgPath // Update the path of the shape node
            }
            
            strokeNode.run(drawStrokeAction)
        }
        
        
        
    }

     func handleTapOnBottomRightPlayer(){
         print("budf")
        strokeNodeBottomRight?.removeFromParent()
        
        let topRightProfilePosition = CGPoint(x: playableRect.maxX - 280, y: playableRect.maxY - 180)
           startStrokeAnimationForPlayer(at: topRightProfilePosition, parentNode: self)
        
    }
    
    func addProfileImagebottomRight() {
        // Add profile image
        let profileImage = SKSpriteNode(imageNamed: "user2")
        profileImage.size = CGSize(width: 100, height: 100)
        profileImage.position = CGPoint(x: playableRect.maxX - 280, y: playableRect.minY + 180) // Adjust position as needed
        addChild(profileImage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            // Remove the profile image after a delay
            profileImage.removeFromParent()
            
            // After another delay, start the stroke animation again
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                let strokeRadius: CGFloat = 52 // Adjust the radius as needed
                let strokeNode = SKShapeNode(circleOfRadius: strokeRadius)
                strokeNode.position = CGPoint(x: playableRect.maxX - 280, y: playableRect.minY + 180)
                strokeNode.strokeColor = .yellow // Set stroke color
                strokeNode.lineWidth = 10
                self.addChild(strokeNode)
                
                self.strokeNodeBottomRight = strokeNode
                
                // Animate the drawing of the stroke
                let drawStrokeAction = SKAction.customAction(withDuration: 10.0) { node, elapsedTime in
                    let progress = elapsedTime / 10.0 // Divide by total duration to get progress from 0 to 1
                    let angle = CGFloat(progress) * 2 * CGFloat.pi // Convert progress to radians (0 to 2π)
                    let path = UIBezierPath(arcCenter: .zero, radius: strokeRadius, startAngle: -CGFloat.pi / 2, endAngle: angle - CGFloat.pi / 2, clockwise: true)
                    (node as! SKShapeNode).path = path.cgPath // Update the path of the shape node
                }
                
//                strokeNode.run(drawStrokeAction)
            }
        }
    }
    func handleTapOnTopRightPlayer(){
        strokeNodeTopRight?.removeFromParent()
        
        let topLeftProfilePosition = CGPoint(x: playableRect.minX + 280, y: playableRect.maxY - 180)
           startStrokeAnimationForPlayer(at: topLeftProfilePosition, parentNode: self)
        
    }

    
    func addProfileImageTopRight() {
        // Add profile image
        let profileImage = SKSpriteNode(imageNamed: "user2")
        profileImage.size = CGSize(width: 100, height: 100)
        profileImage.position = CGPoint(x: playableRect.maxX - 280, y: playableRect.maxY - 180) // Adjust position as needed
        addChild(profileImage)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            // Remove the profile image after a delay
            profileImage.removeFromParent()
            
            // After another delay, start the stroke animation again
            DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) { [self] in
                let strokeRadius: CGFloat = 52 // Adjust the radius as needed
                let strokeNode = SKShapeNode(circleOfRadius: strokeRadius)
                strokeNode.position = CGPoint(x: playableRect.maxX - 280, y: playableRect.minY + 180)
                strokeNode.strokeColor = .yellow // Set stroke color
                strokeNode.lineWidth = 10
                self.addChild(strokeNode)
                
                self.strokeNodeTopRight = strokeNode
                
                // Animate the drawing of the stroke
                let drawStrokeAction = SKAction.customAction(withDuration: 10.0) { node, elapsedTime in
                    let progress = elapsedTime / 10.0 // Divide by total duration to get progress from 0 to 1
                    let angle = CGFloat(progress) * 2 * CGFloat.pi // Convert progress to radians (0 to 2π)
                    let path = UIBezierPath(arcCenter: .zero, radius: strokeRadius, startAngle: -CGFloat.pi / 2, endAngle: angle - CGFloat.pi / 2, clockwise: true)
                    (node as! SKShapeNode).path = path.cgPath // Update the path of the shape node
                }
                
                strokeNode.run(drawStrokeAction)
            }
        }
            }
    
    func addProfileImageTopLeft() {
        // Add profile image
        let profileImage = SKSpriteNode(imageNamed: "user2")
        profileImage.size = CGSize(width: 100, height: 100)
        profileImage.position = CGPoint(x: playableRect.minX + 280, y: playableRect.maxY - 180) // Adjust position as needed
        addChild(profileImage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
            let strokeRadius: CGFloat = 52 // Adjust the radius as needed
            let strokeNode = SKShapeNode(circleOfRadius: strokeRadius)
            strokeNode.position = profileImage.position
            strokeNode.strokeColor = .yellow // Set stroke color
            strokeNode.lineWidth = 10
            self.addChild(strokeNode)
            
            // Animate the drawing of the stroke
            let drawStrokeAction = SKAction.customAction(withDuration: 10.0) { node, elapsedTime in
                let progress = elapsedTime / 10.0 // Divide by total duration to get progress from 0 to 1
                let angle = CGFloat(progress) * 2 * CGFloat.pi // Convert progress to radians (0 to 2π)
                let path = UIBezierPath(arcCenter: .zero, radius: strokeRadius, startAngle: -CGFloat.pi / 2, endAngle: angle - CGFloat.pi / 2, clockwise: true)
                (node as! SKShapeNode).path = path.cgPath // Update the path of the shape node
            }
            
            strokeNode.run(drawStrokeAction)
        }
      
    }

}

