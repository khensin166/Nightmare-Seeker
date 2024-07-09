import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Initial declaration
    var character: SKSpriteNode!
    var bgDark: SKSpriteNode!
    var chair: SKSpriteNode!
    var motionManager: CMMotionManager!
    var scoreLabel: SKLabelNode!
    var score: Int = 0
    var passChair: Int = 0
    
    let xPosition = [90, 0, -90]
    
/*  
    Struktur PhysicsCategories digunakan untuk mendefinisikan kategori fisika menggunakan bitmask,
    yang memungkinkan pengaturan interaksi dan deteksi kontak antara objek dalam permainan
*/
    struct PhysicsCategories {
        static let none: UInt32 = 0
        static let character: UInt32 = 0x1 << 0
        static let kursi: UInt32 = 0x1 << 1
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        chair = self.childNode(withName: "//kursi1") as? SKSpriteNode
        
        // Ambil node "character" dari sks atau buat manual
        bgDark = self.childNode(withName: "//bgDark") as? SKSpriteNode
        bgDark.zPosition = 5 // Pastikan bgDark berada di depan kursi
        
        if let existingChar = self.childNode(withName: "//character") as? SKSpriteNode {
            character = existingChar
        } else {
            character = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
            character.zPosition = 10 // Pastikan ini berada di depan bg
            addChild(character)
        }
        
        let miniCharacterSize = CGSize(width: character.size.width * 0.8, height: character.size.height * 0.8)
        
        // Kecilkan physic character
        character.size = miniCharacterSize
        
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
    
    func repeatedlySpawnKursi1() {
        let spawnAction = SKAction.run {
                    self.spawnChair()
                }
                
        let waitAction = SKAction.wait(forDuration: TimeInterval.random(in: 3...6)) // Durasi acak antara 3 hingga 6 detik
                
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
                
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func spawnChair() {
        guard let newChair = chair?.copy() as? SKSpriteNode else { return }
        
        newChair.position = CGPoint(x: xPosition[Int.random(in: 0...1)], y: 700)
        newChair.zPosition = 4 // Pastikan kursi berada di belakang bgDark
        
        // Ubah ukuran physics body menjadi lebih kecil
        let smallerPhysicsBodySize = CGSize(width: newChair.size.width * 0.8, height: newChair.size.height * 0.8)
        newChair.physicsBody = SKPhysicsBody(rectangleOf: smallerPhysicsBodySize)
        newChair.physicsBody?.isDynamic = false
        newChair.physicsBody?.categoryBitMask = PhysicsCategories.kursi
        newChair.physicsBody?.contactTestBitMask = PhysicsCategories.character
        newChair.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(newChair)
        
        moveChair(node: newChair)
    }
    
    func moveChair(node: SKNode) {
        let duration = TimeInterval.random(in: 6...10) // Durasi acak antara 2 hingga 5 detik untuk variasi kecepatan
        let moveDownAction = SKAction.moveTo(y: -700, duration: duration)
                
        let removeNodeAction = SKAction.run {
            self.passChair += 1
            self.score = self.passChair // Update score based on passed kursi
            self.updateScore()
            node.removeFromParent()
        }
                
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
        let threshold: Double = 0.02
        
        // Jika perubahan pada akselerometer kurang dari ambang batas, abaikan perubahan
        guard abs(acceleration.x) > threshold else { return }
        
        let moveSpeed: CGFloat = 100.0 // Kecepatan gerakan, sesuaikan dengan kebutuhan
        let maxXPosition: CGFloat = frame.size.width / 2 - character.size.width // Batas posisi X agar tidak keluar dari layar
        
        let newX = character.position.x + CGFloat(acceleration.x * moveSpeed)
        let adjustedX = max(-maxXPosition, min(maxXPosition, newX))
        
        let bgDarkMoveAmount = character.position.x - adjustedX
        bgDark.position.x -= bgDarkMoveAmount
        character.position.x = adjustedX
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == (PhysicsCategories.character | PhysicsCategories.kursi) {
            showGameOver()
        }
    }
    
    func updateScore() {
        scoreLabel.text = "Score: \(score)"
    }
    
    func showGameOver() {
        if let gameOverScene = SKScene(fileNamed: "GameOverScene") {
            let transition = SKTransition.fade(withDuration: 1.0)
            view?.presentScene(gameOverScene, transition: transition)
        }
    }
}
