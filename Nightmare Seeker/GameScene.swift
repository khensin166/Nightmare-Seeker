import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var character: SKSpriteNode!
    var bgDark: SKSpriteNode!
    var kursi1: SKSpriteNode!
    var motionManager: CMMotionManager!
    var scoreLabel: SKLabelNode!
    var score: Int = 0
    
    let xPosition = [90, -90]
    
    struct PhysicsCategories {
        static let none: UInt32 = 0
        static let character: UInt32 = 0x1 << 0
        static let kursi: UInt32 = 0x1 << 1
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        kursi1 = self.childNode(withName: "//kursi1") as? SKSpriteNode
        
        // Ambil node "character" dari sks atau buat manual
        bgDark = self.childNode(withName: "//bgDark") as? SKSpriteNode
        if let existingChar = self.childNode(withName: "//character") as? SKSpriteNode {
            character = existingChar
        } else {
            character = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
            character.zPosition = 10 // Pastikan ini berada di depan bg
            addChild(character)
        }

        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.affectedByGravity = false
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.isDynamic = true
        character.physicsBody?.categoryBitMask = PhysicsCategories.character
        character.physicsBody?.contactTestBitMask = PhysicsCategories.kursi
        character.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        // Buat label skor
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: frame.minX + 20, y: frame.maxY - 40)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 100
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        // Mulai membaca data accelerometer
        startAccelerometer()
        
        repeatedlySpawnKursi1()
    }
    
    func repeatedlySpawnKursi1(){
        let spawnAction = SKAction.run {
            self.spawnKursi1()
        }
        
        let waitAction = SKAction.wait(forDuration: 2)
        
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])

        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func spawnKursi1(){
        let newKursi1 = kursi1?.copy() as! SKSpriteNode
        
        newKursi1.position = CGPoint(x: xPosition[Int.random(in: 0...1)], y: 700)
        newKursi1.physicsBody = SKPhysicsBody(rectangleOf: newKursi1.size)
        newKursi1.physicsBody?.isDynamic = false
        newKursi1.physicsBody?.categoryBitMask = PhysicsCategories.kursi
        newKursi1.physicsBody?.contactTestBitMask = PhysicsCategories.character
        newKursi1.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(newKursi1)
        
        moveKursi1(node: newKursi1)
    }
    
    func moveKursi1(node: SKNode){
        let moveDownAction = SKAction.moveTo(y: -700, duration: 4)
        let removeNodeAction = SKAction.removeFromParent()
        
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
    }
    
    func startAccelerometer() {
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.1
        
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer is not available")
            return
        }
        
        motionManager.startAccelerometerUpdates(to: .main) { (accelerometerData, error) in
            guard let acceleration = accelerometerData?.acceleration else {
                print("Failed to get accelerometer data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.updatePositionWith(acceleration: acceleration)
        }
    }
    
    func updatePositionWith(acceleration: CMAcceleration) {
        let moveSpeed: CGFloat = 100.0
        let maxXPosition: CGFloat = frame.size.width / 2 - character.size.width / 2
        
        let newX = character.position.x + CGFloat(acceleration.x * moveSpeed)
        let adjustedX = max(-maxXPosition, min(maxXPosition, newX))
        
        let bgDarkMoveAmount = character.position.x - adjustedX
        
        bgDark.position.x -= bgDarkMoveAmount
        character.position.x = adjustedX
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == (PhysicsCategories.character | PhysicsCategories.kursi) {
            score += 1
            scoreLabel.text = "Score: \(score)"
        }
    }
}

