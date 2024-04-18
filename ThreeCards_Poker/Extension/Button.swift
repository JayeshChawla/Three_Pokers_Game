import SpriteKit

class ButtonScene: SKNode {

    var button : SKSpriteNode
    private var mask : SKSpriteNode
    private var cropnode : SKCropNode
    private var action : () -> Void
    var isEnabled : Bool = true
    var tittleLabel : SKLabelNode?
    
    init(imageNamed : String , tittle : String? =  "" , buttonAction : @escaping() -> Void){
        button = SKSpriteNode(imageNamed: imageNamed)
        button.size = CGSize(width: 100, height: 60)
        
        tittleLabel = SKLabelNode(text: tittle)
        
        mask = SKSpriteNode(color: SKColor.black, size: button.size)
        mask.alpha = 0
        
        cropnode = SKCropNode()
        cropnode.maskNode = button
        cropnode.zPosition = 3
        cropnode.addChild(mask)
        
        action = buttonAction
        super.init()
        
        isUserInteractionEnabled = true
        setupNode()
        addnodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNode(){
        button.zPosition = 0
        
        if let tittleLabel = tittleLabel {
            tittleLabel.fontName = ""
            tittleLabel.fontSize = 30
            tittleLabel.fontColor = SKColor.white
            tittleLabel.zPosition = 1
            tittleLabel.horizontalAlignmentMode = .center
            tittleLabel.verticalAlignmentMode = .center
        }
    }
    func addnodes(){
        addChild(cropnode)
        addChild(button)
        
        if let tittleLabel = tittleLabel {
            addChild(tittleLabel)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled{
            mask.alpha = 0.5
            run(SKAction.scale(by: 1.05, duration: 0.05))
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            for touch in touches {
                let location : CGPoint = touch.location(in: self)
                
                if button.contains(location){
                    mask.alpha = 0.5
                } else{
                    mask.alpha = 0.0
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled{
            for touch in touches {
                let location : CGPoint = touch.location(in: self)
                if button.contains(location){
                    disabled()
                    action()
                    run(SKAction.sequence([SKAction.wait(forDuration: 0.2), SKAction.run {
                        self.enable()
                    }]))
                }
            }
        }
    }
    func disabled(){
        isEnabled = false
        mask.alpha = 0.0
        button.alpha = 0.5
    }
    func enable(){
        isEnabled = true
        mask.alpha = 0.0
        button.alpha = 1.0
    }
}
