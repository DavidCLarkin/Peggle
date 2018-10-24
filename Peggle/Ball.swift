//
//  Bouncer.swift
//  Peggle
//
//  Created by David Larkin on 22/10/2018.
//  Copyright © 2018 20070186. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Ball : SKSpriteNode
{
    var bouncersHit = 0
    var boxesHit = 0
    var ballArray = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
    
    init()
    {
        let chosen = GKRandomSource.sharedRandom().nextInt(upperBound: ballArray.count)
        let texture = SKTexture(imageNamed: ballArray[chosen])
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func setBouncersHit(increaseBy: Int)
    {
        bouncersHit = bouncersHit + increaseBy
    }
}
