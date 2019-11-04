//
//  Cell.swift
//  GameOfLife
//
//  Created by Felipe Petersen on 01/11/19.
//  Copyright © 2019 Felipe Petersen. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit

class Cell: SCNNode {
    
    var x: Float?
    var y: Float?
    var z: Float?
//
//    init(x: Float, y:Float, z: Float) {
//        super.init()
//        self.x = x
//        self.x = y
//        self.z = z
//    }
    
    func createBox(x: Float, y: Float, z: Float) -> SCNNode {
        let boxGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.1)
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.position = SCNVector3(x, y, z)
        return boxNode
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
