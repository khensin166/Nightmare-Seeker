import SpriteKit
import GameplayKit
import CoreMotion
import AudioToolbox
import CoreHaptics
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // declaration
    var character: SKSpriteNode!
    var bgDark: SKSpriteNode!
    var chair: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var hantu1: SKSpriteNode!
    var hantu2: SKSpriteNode!
    var road: SKSpriteNode!
    var startGameCounter: SKSpriteNode!

    var audioPlayer: AVAudioPlayer?
    var ghostAudioPlayer: AVAudioPlayer?
    
    var motionManager: CMMotionManager!
    
    var hapticEngine: CHHapticEngine?
    
    var score: Int = 0
    var passChair: Int = 0
    
    let xPosition = [90, 0, -90]
    
    // Structure for physics categories
    struct PhysicsCategories {
        static let none: UInt32 = 0
        static let character: UInt32 = 0x1 << 0
        static let kursi: UInt32 = 0x1 << 1
        static let hantu: UInt32 = 0x1 << 2
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        chair = self.childNode(withName: "//kursi1") as? SKSpriteNode
        
        hantu1 = self.childNode(withName: "//hantu1") as? SKSpriteNode
        
        hantu2 = self.childNode(withName: "//hantu2") as? SKSpriteNode
        
        bgDark = self.childNode(withName: "//bgDark") as? SKSpriteNode
//        bgDark.zPosition = 5

        startGameCounter = self.childNode(withName: "//startGameCounter") as? SKSpriteNode
        road = self.childNode(withName: "//road") as? SKSpriteNode
        
        character = self.childNode(withName: "//character") as? SKSpriteNode
        // Debug prints
            if chair == nil {
                print("Error: Chair node not found!")
            }
            if bgDark == nil {
                print("Error: bgDark node not found!")
            }
            if character == nil {
                print("Error: Character node not found!")
            }
            if startGameCounter == nil {
                print("Error: Start Game Counter node not found!")
            }

            guard let character = character else {
                fatalError("Character node is nil!")
            }

        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.affectedByGravity = false
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.isDynamic = true
        
        character.physicsBody?.categoryBitMask = PhysicsCategories.character
        character.physicsBody?.contactTestBitMask = PhysicsCategories.kursi | PhysicsCategories.hantu
        character.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        // Buat label skor
                scoreLabel = SKLabelNode(fontNamed: "Arial")
                scoreLabel.fontSize = 40
                scoreLabel.fontColor = SKColor.white
                scoreLabel.position = CGPoint(x: frame.minX + 130, y: frame.maxY - 150)
                scoreLabel.horizontalAlignmentMode = .left
                scoreLabel.zPosition = 100
                scoreLabel.text = "Score: 0"
                addChild(scoreLabel)
        
        startGameCountDown()
        
        repeatedlySpawnKursi1()
        
        prepareHaptics()
        
        prepareCollisionSound()
    }
    
    func startGameCountDown() {
        // Pause all nodes except startGameCounter
                for node in self.children {
                    if node != startGameCounter {
//                        print("\(node.name) is paused!")
                        node.isPaused = true
                        node.removeAllActions()
                    }
                }
                // Stop accelerometer updates
                self.stopAccelerometer()
                
                let countdown = SKAction.sequence([
                    SKAction.run { self.startGameCounter.isHidden = false },
                    SKAction.wait(forDuration: 2.5),
                    SKAction.run {
                        self.startGameCounter.removeFromParent()
                        for node in self.children {
                            node.isPaused = false
                        }
                        // Restart accelerometer updates
                        self.startAccelerometer()
                        self.animateTextureChar()
                        self.animateTextureRoad()
                    }
                ])
                
                startGameCounter.run(countdown)
    }
    //    animated character walk programmatically
        func animateTextureChar() {
            let textures = [SKTexture(imageNamed: "char1"), SKTexture(imageNamed: "char2"), SKTexture(imageNamed: "char3"), SKTexture(imageNamed: "char4") ]
            let animateCharacter = SKAction.animate(with: textures, timePerFrame: 0.25)
            let repeatAnimation = SKAction.repeatForever(animateCharacter)
            
            character.run(repeatAnimation)
        }
        
    //    animated texture road programmatically
        func animateTextureRoad() {
            let textures = [SKTexture(imageNamed: "bgGame1"), SKTexture(imageNamed: "bgGame2"), SKTexture(imageNamed: "bgGame3"), SKTexture(imageNamed: "bgGame4") ]
            let animateRoad = SKAction.animate(with: textures, timePerFrame: 0.25)
            let repeatAnimation = SKAction.repeatForever(animateRoad)
            
            road.run(repeatAnimation)
        }

    func repeatedlySpawnKursi1() {
        let spawnAction = SKAction.run {
            self.spawnChair()
        }
        
        let waitAction = SKAction.wait(forDuration: TimeInterval.random(in: 3...6))
        
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func spawnChair() {
        guard let newChair = chair?.copy() as? SKSpriteNode else { return }
        
        newChair.position = CGPoint(x: xPosition[Int.random(in: 0...1)], y: 700)
        newChair.zPosition = 4
        
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
        let duration = TimeInterval.random(in: 6...10)
        let moveDownAction = SKAction.moveTo(y: -700, duration: duration)
        
        let removeNodeAction = SKAction.run {
            self.passChair += 1
            self.score = self.passChair
            self.updateScore()
            node.removeFromParent()
            self.spawnHantuRandomly()
        }
        
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
    }
    
    func spawnHantuRandomly() {
        let chance = Int.random(in: 1...10)
        if chance <= 3 {
            guard let newHantu = hantu1?.copy() as? SKSpriteNode else { return }
            
            let randomX = xPosition[Int.random(in: 0...2)]
            newHantu.position = CGPoint(x: randomX, y: 700)
            newHantu.zPosition = 4
            
            newHantu.physicsBody = SKPhysicsBody(rectangleOf: newHantu.size)
            newHantu.physicsBody?.isDynamic = true
            newHantu.physicsBody?.affectedByGravity = false
            newHantu.physicsBody?.categoryBitMask = PhysicsCategories.hantu
            newHantu.physicsBody?.contactTestBitMask = PhysicsCategories.character
            newHantu.physicsBody?.collisionBitMask = PhysicsCategories.none
            
            newHantu.setScale(0.5)
            
            addChild(newHantu)
            
            let moveDownAction = SKAction.moveTo(y: -700, duration: TimeInterval.random(in: 6...10))
            let removeAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveDownAction, removeAction])
            newHantu.run(sequence)
            
            playGhostSound()
            
            flashScreen()
            
            let scaleUpAction = SKAction.scale(to: 0.6, duration: 0.2)
            let scaleDownAction = SKAction.scale(to: 0.5, duration: 0.2)
            let scaleSequence = SKAction.sequence([scaleUpAction, scaleDownAction])
            newHantu.run(scaleSequence)
            
            let blinkAction = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.1, duration: 0.1),
                SKAction.wait(forDuration: 0.2),
                SKAction.fadeAlpha(to: 1.0, duration: 0.1)
            ])
            newHantu.run(SKAction.repeatForever(blinkAction))
            
            let moveSideAction = SKAction.moveBy(x: CGFloat.random(in: -50...50), y: 0, duration: 0.5)
            let moveSequence = SKAction.sequence([moveSideAction, moveSideAction.reversed()])
            newHantu.run(SKAction.repeatForever(moveSequence))
        }

               if chance <= 3 {
                   guard let newHantu = hantu2?.copy() as? SKSpriteNode else { return }
                   
                   let randomX = xPosition[Int.random(in: 0...2)]
                   newHantu.position = CGPoint(x: randomX, y: 700)
                   newHantu.zPosition = 4
                   
                   newHantu.physicsBody = SKPhysicsBody(rectangleOf: newHantu.size)
                   newHantu.physicsBody?.isDynamic = true
                   newHantu.physicsBody?.affectedByGravity = false
                   newHantu.physicsBody?.categoryBitMask = PhysicsCategories.hantu
                   newHantu.physicsBody?.contactTestBitMask = PhysicsCategories.character
                   newHantu.physicsBody?.collisionBitMask = PhysicsCategories.none
                   
                   newHantu.setScale(0.2) // Ukuran hantu diperkecil menjadi 0.2
                   
                   addChild(newHantu)
                   
                   let moveDownAction = SKAction.moveTo(y: -700, duration: TimeInterval.random(in: 6...10))
                   let removeAction = SKAction.removeFromParent()
                   let sequence = SKAction.sequence([moveDownAction, removeAction])
                   newHantu.run(sequence)
                   
                   playGhostSound()
                   
                   flashScreen()
                   
                   // Tambahkan efek mendekat dan menakutkan
                   let scaleUpAction = SKAction.scale(to: 1.5, duration: 1.0) // Perbesar ukuran hantu
                   let moveToFrontAction = SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY), duration: 1.0) // Pindahkan hantu ke tengah layar
                   let changeZPosition = SKAction.run {
                       newHantu.zPosition = 1000 // Tempatkan hantu di depan
                   }
                   
                   let scarySequence = SKAction.group([scaleUpAction, moveToFrontAction, changeZPosition])
                   
                   // Efek getaran
                   let shakeAction = SKAction.sequence([
                       SKAction.moveBy(x: -10, y: 0, duration: 0.05),
                       SKAction.moveBy(x: 20, y: 0, duration: 0.05),
                       SKAction.moveBy(x: -10, y: 0, duration: 0.05),
                   ])
                   
                   let repeatShake = SKAction.repeat(shakeAction, count: 5)
                   
                   let fullSequence = SKAction.sequence([scarySequence, repeatShake, SKAction.wait(forDuration: 0.5), removeAction])
                   newHantu.run(fullSequence)
                   
                   // Blink action
                   let blinkAction = SKAction.sequence([
                       SKAction.fadeAlpha(to: 0.1, duration: 0.1),
                       SKAction.wait(forDuration: 0.2),
                       SKAction.fadeAlpha(to: 1.0, duration: 0.1)
                   ])
                   newHantu.run(SKAction.repeatForever(blinkAction))
                   
                   // Move side action
                   let moveSideAction = SKAction.moveBy(x: CGFloat.random(in: -50...50), y: 0, duration: 0.5)
                   let moveSequence = SKAction.sequence([moveSideAction, moveSideAction.reversed()])
                   newHantu.run(SKAction.repeatForever(moveSequence))
               }
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
    
    func stopAccelerometer() {
            if let motionManager = motionManager, motionManager.isAccelerometerActive {
                motionManager.stopAccelerometerUpdates()
            }
        }
    
    
    func updatePositionWith(acceleration: CMAcceleration) {
        let maxAccelerationX: Double = 1.0 // Ambang percepatan maksimum
        let maxMoveSpeed: CGFloat = 100.0 // Kecepatan maksimum per pergerakan
        
        // Mengukur percepatan mutlak
        let absoluteAccelerationX = abs(acceleration.x)
        
        // Jika percepatan melebihi ambang maksimum
        if absoluteAccelerationX > maxAccelerationX {
            // Memanggil fungsi showGameOver() untuk menampilkan scene game over
            showGameOver()
            return
        }
        
        // Menghitung perubahan posisi karakter
        let moveAmount = CGFloat(acceleration.x * maxMoveSpeed)
        
        // Batas-batas posisi karakter
        let maxXPosition = frame.size.width / 2 - character.size.width * 2
        let minXPosition = -maxXPosition
        
        // Memeriksa batas-batas posisi yang valid
        let newX = character.position.x + moveAmount
        let adjustedX = max(minXPosition, min(maxXPosition, newX))
        
        // Pembaruan posisi karakter
        let bgDarkMoveAmount = character.position.x - adjustedX
        bgDark.position.x -= bgDarkMoveAmount
        character.position.x = adjustedX
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == (PhysicsCategories.character | PhysicsCategories.kursi) {
            playHaptic()
            playCollisionSound()
            showGameOver()
        } else if collision == (PhysicsCategories.character | PhysicsCategories.hantu) {
            playHaptic()
            playGhostCollisionSound()
            
            // Pemeriksaan sentuhan antara karakter dan hantu1
            if (contact.bodyA.categoryBitMask == PhysicsCategories.character && contact.bodyB.categoryBitMask == PhysicsCategories.hantu) ||
               (contact.bodyA.categoryBitMask == PhysicsCategories.hantu && contact.bodyB.categoryBitMask == PhysicsCategories.character) {
                
                showGameOver()
            }
        }
    }

    func distanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return sqrt(dx * dx + dy * dy)
    }

    
    
    func showGameOver() {
        if let gameOverScene = SKScene(fileNamed: "GameOverScene") {
            let transition = SKTransition.fade(withDuration: 3.0)
            view?.presentScene(gameOverScene, transition: transition)
            
            self.stopAccelerometer()
            NotificationCenter.default.post(name: NSNotification.Name("GameOver"), object: nil, userInfo: ["score": score])
        }
    }
    
    func updateScore() {
        scoreLabel.text = "Score: \(score)"
        
        // Periksa apakah skor mencapai 50
        if score >= 50 {
            showGameFinish()
        }
    }

    func showGameFinish() {
        if let gameFinishScene = SKScene(fileNamed: "GameFinishScene") {
            let transition = SKTransition.fade(withDuration: 3.0)
            view?.presentScene(gameFinishScene, transition: transition)
            
            self.stopAccelerometer()
            NotificationCenter.default.post(name: NSNotification.Name("GameFinish"), object: nil, userInfo: ["score": score])
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("There was an error creating the haptic engine: \(error.localizedDescription)")
        }
    }
    
    func playHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play haptic pattern: \(error.localizedDescription)")
        }
    }
    
    func prepareCollisionSound() {
        if let soundURL = Bundle.main.url(forResource: "collision", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Failed to load collision sound: \(error.localizedDescription)")
            }
        }
    }
    
    func playCollisionSound() {
        audioPlayer?.play()
    }
    
    func playGhostSound() {
        if let soundURL = Bundle.main.url(forResource: "suarahantu", withExtension: "mp3") {
            do {
                ghostAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                ghostAudioPlayer?.prepareToPlay()
                ghostAudioPlayer?.play()
            } catch {
                print("Failed to load ghost sound: \(error.localizedDescription)")
            }
        }
    }
    
    func playGhostCollisionSound() {
        if let soundURL = Bundle.main.url(forResource: "collision", withExtension: "mp3") {
            do {
                ghostAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                ghostAudioPlayer?.prepareToPlay()
                ghostAudioPlayer?.play()
            } catch {
                print("Failed to load ghost collision sound: \(error.localizedDescription)")
            }
        }
    }
    
    func flashScreen() {
        let flash = SKSpriteNode(color: .white, size: self.size)
        flash.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        flash.zPosition = 1000
        flash.alpha = 0.0
        addChild(flash)
        
        let fadeInAction = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        let fadeOutAction = SKAction.fadeAlpha(to: 0.0, duration: 0.1)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeInAction, fadeOutAction, removeAction])
        
        flash.run(sequence)
    }
}


