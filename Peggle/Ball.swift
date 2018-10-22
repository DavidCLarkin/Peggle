//
//  Bouncer.swift
//  Peggle
//
//  Created by David Larkin on 22/10/2018.
//  Copyright © 2018 20070186. All rights reserved.
//

import Foundation
import SpriteKit

class Ball
{
    var node : SKSpriteNode
    var bouncersHit = 0
    
    init(node: SKSpriteNode)
    {
        self.node = node
    }
    
    func setBouncersHit(increaseBy: Int)
    {
        bouncersHit = bouncersHit + increaseBy
    }
}
