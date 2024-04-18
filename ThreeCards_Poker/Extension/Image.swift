import CoreGraphics
import SpriteKit
class Image {
    static func createImageNode(imageNamed : String , size : CGSize , postion : CGPoint) -> SKSpriteNode{
        let imageNode = SKSpriteNode(imageNamed: imageNamed)
        imageNode.size = size
        imageNode.position = postion
        return imageNode
    }
}
