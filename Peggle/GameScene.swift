import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var boxes = [SKSpriteNode]()
    var ballsInPlay = [Ball]()
    let MAX_BALLS : Int = 10
    var gameOver = false
    {
        didSet
        {
            if gameOver
            {
                resetGame()
                print("Game Over")
            }
        }
    }
    
    var ballLabel: SKLabelNode!
    var currentBalls = 5
    {
        didSet
        {
            //print(currentBalls)
            if currentBalls >= MAX_BALLS
            {
                currentBalls = MAX_BALLS
            }
            ballLabel.text = "Balls Left: \(currentBalls)"
        }
    }
    
    var scoreLabel: SKLabelNode!
    var score = 0
    {
        didSet
        {
            if score <= 0
            {
                score = 0
            }
            scoreLabel.text = "score: \(score)"
        }
    }
    
    var restartLabel: SKLabelNode!
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = false
    {
        didSet
        {
            if editingMode
            {
                editLabel.text = "Done"
            }
            else
            {
                editLabel.text = "Edit"
            }
        }
    }

    
    override func didMove(to view: SKView)
    {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        ballLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballLabel.text = "Balls Left: \(currentBalls)"
        ballLabel.position = CGPoint(x: 300, y: 700)
        addChild(ballLabel)
        
        restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLabel.text = "Restart"
        restartLabel.position = CGPoint(x: 600, y: 700)
        addChild(restartLabel)
        
        makeBoxes(numOfBoxes: 20) // make boxes
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first
        {
            let location = touch.location(in: self) //location where mouse click?
            let objects = nodes(at: location)
            if objects.contains(editLabel)
            {
                editingMode = !editingMode
            }
            if objects.contains(restartLabel)
            {
                resetGame()
            }
            else
            {
                if editingMode
                {
                    for object in objects
                    {
                        if object.name == "box"
                        {
                            object.removeFromParent()
                            return
                        }
                    }
                    let size = CGSize(width: GKRandomDistribution(lowestValue: 16, highestValue: 128).nextInt(), height: 16)
                    let box = SKSpriteNode(color: RandomColor(), size: size)
                    box.zRotation = RandomCGFloat(min: 0, max: 3)
                    box.position = location
                    
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    box.name = "box"
                    boxes.append(box)
                    addChild(box)
                }
                else
                {
                    if currentBalls > 0
                    {
                        let ball = Ball()
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                        ball.physicsBody?.restitution = 0.4
                        ball.position.x = location.x //set box position at mouse click
                        ball.position.y = (self.view?.bounds.height)!
                        ball.name = "ball"
                        addChild(ball)
                        //ballsInPlay.append(ball)
                        currentBalls -= 1
                    }
                    else if currentBalls <= 0
                    {
                        gameOver = true
                    }
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint)
    {
        let bouncer = SKSpriteNode(imageNamed: "bouncer.png")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        bouncer.name = "bouncer"
        addChild(bouncer)
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        guard let nodeA = contact.bodyA.node else {  return  }
        guard let nodeB = contact.bodyB.node else {  return  }
        
        if nodeA.name == "ball"
        {
            collisionBetween(ball: nodeA as! Ball, object: nodeB)
        }
        else if nodeB.name == "ball"
        {
            collisionBetween(ball: nodeB as! Ball, object: nodeA)
        }
    }
    
    func makeBoxes(numOfBoxes: Int)
    {
        var num = numOfBoxes
        while num > 0
        {
            let height = self.view?.bounds.height
            let width = self.view?.bounds.width
            let size = CGSize(width: GKRandomDistribution(lowestValue: 32, highestValue: 128).nextInt(), height: 16)
            let box = SKSpriteNode(color: RandomColor(), size: size)
            box.zRotation = RandomCGFloat(min: 0, max: 3)
            box.position = CGPoint(x: GKRandomDistribution(lowestValue: 100, highestValue: Int(width! - CGFloat(100))).nextInt(), y: GKRandomDistribution(lowestValue: 150, highestValue: Int(height! - CGFloat(200))).nextInt())
            
            box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
            box.physicsBody?.isDynamic = false
            box.name = "box"
            boxes.append(box)
            addChild(box)
            
            //choose random boxes to spin or not to spin
            let rotate = GKRandomDistribution(lowestValue: 0, highestValue: 1).nextInt()
            if rotate == 1
            {
                let spin = SKAction.rotate(byAngle: .pi / 2, duration: 10)
                let spinForever = SKAction.repeatForever(spin)
                box.run(spinForever)
            }
            num -= 1
        }
        
        //move boxes if really close, still overlaps sometimes
        for i in 0...boxes.count-1
        {
            for j in 1...boxes.count-1
            {
                if CGPointDistance(from: boxes[i].position, to: boxes[j].position) <= 50
                {
                    boxes[i].position.x += 20
                    boxes[i].position.y -= 20
                    boxes[j].position.x -= 20
                    boxes[j].position.y += 20
                }
            }
        }
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool)
    {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood
        {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood.png")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood.png")
            slotBase.name = "good"
        }
        else
        {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad.png")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad.png")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false //not dynamic because dont want it to move when collides with ball
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: Ball, object: SKNode)
    {
        if object.name == "good"
        {
            destroy(ball: ball)
            score += 1
            currentBalls += 1
        }
        else if object.name == "bad"
        {
            destroy(ball: ball)
            //score -= 1
        }
        else if object.name == "box"
        {
            if ball.boxesHit >= 2
            {
                score += 1
                ball.boxesHit = 0
            }
            else
            {
                ball.boxesHit += 1
            }
            
            destroy(box: object)
        }
        else if object.name == "bouncer"
        {
            if ball.bouncersHit == 1
            {
                let action = SKAction.move(to: CGPoint(x: GKRandomSource.sharedRandom().nextInt(upperBound: 1024), y: 750), duration: 0)
                ball.run(action)
                ball.bouncersHit = 0
            }
            else
            {
                ball.setBouncersHit(increaseBy: 1)
            }
        }
    }
    
    func destroy(ball: SKNode)
    {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles")
        {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
        //currentBalls -= 1
    }
    
    func destroy(box: SKNode)
    {
        box.removeFromParent()
    }
    
    func resetGame()
    {
        score = 0
        for box in boxes
        {
            box.removeFromParent()
        }
        boxes.removeAll()
        
        for ball in ballsInPlay
        {
            ball.removeFromParent()
        }
        ballsInPlay.removeAll()
        currentBalls = 5
        makeBoxes(numOfBoxes: 20)
        gameOver = false
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat
    {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat
    {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    
}
