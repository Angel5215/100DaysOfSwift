//
//  PortalPair.swift
//  Project26
//
//  Created by Angel Vázquez on 5/11/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import SpriteKit

class PortalPair {
    private var first: SKSpriteNode!
    private var second: SKSpriteNode!
    
    func getPair() -> (first: SKSpriteNode, second: SKSpriteNode) {
        return (first, second)
    }
    
    func setFirstPortal(_ portal: SKNode) {
        guard let portal = portal as? SKSpriteNode else {
            fatalError("Error while setting portals")
        }
        first = portal
    }
    
    func setSecondPortal(_ portal: SKNode) {
        guard let portal = portal as? SKSpriteNode else {
            fatalError("Error while setting portals")
        }
        second = portal
    }
}
