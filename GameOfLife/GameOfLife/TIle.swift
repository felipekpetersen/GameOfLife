//
//  TIle.swift
//  GameOfLife
//
//  Created by Felipe Petersen on 01/11/19.
//  Copyright © 2019 Felipe Petersen. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit

class Tile: SCNNode {
    var z: Float?
    var x: Float?
    var isSelected = false
    
    init(z: Float, x: Float, isSelected: Bool) {
        super.init()
        self.z = z
        self.x = x
        self.isSelected = isSelected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
