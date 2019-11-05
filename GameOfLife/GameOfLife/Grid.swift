//
//  Grid.swift
//  GameOfLife
//
//  Created by Felipe Petersen on 01/11/19.
//  Copyright © 2019 Felipe Petersen. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit

class GridModel {
    
    var height: Int?
    var width: Int?
    var gridNodes = [SCNNode]()
    var box = Cell()
    var tiles = [Tile]()
    
    init() {
        createGrid()
    }
    
    func createGrid() {
        let geometry = SCNBox(width: 1 , height: 0,
                               length: 1, chamferRadius: 0.005)
        geometry.firstMaterial?.diffuse.contents = UIColor.red
        geometry.firstMaterial?.specular.contents = UIColor.white
        geometry.firstMaterial?.emission.contents = UIColor.blue
        let boxnode = SCNNode(geometry: geometry)
        let offset: Int = 0

        for zIndex:Int in 0...9 {
            for xIndex:Int in 0...9 {
                let boxCopy = boxnode.copy() as! SCNNode
                boxCopy.position.x = Float(xIndex - offset)
                boxCopy.position.z = Float(zIndex - offset)
                self.gridNodes.append(boxCopy)
                let tile = Tile(z: Float(zIndex), x: Float(xIndex), isSelected: false)
                self.tiles.append(tile)
//                self.selectedNodes[zIndex].[xIndex]
            }
        }
    }
    
    func setBoxToPosition(x: Float, y: Float, z: Float) -> SCNNode? {
        let setBox = box.createBox(x: x, y: y, z: z)
        for node in gridNodes {
            if node.position.x == x, node.position.z == z {
                let tile = tiles.first(where: { $0.x == x && $0.z == z })
                if tile?.isSelected == false {
                    tile?.isSelected = true
                    return setBox
                }
            }
        }
        return nil
    }
    
    func emptyNodes() {
        tiles.removeAll()
    }
    
    func getNewBoxes() -> [Cell] {
        var boxes = [Cell]()
//        var auxTiles = []
        for tile in tiles {
            let numberOfSelectedAround = checkNumberOfBoxesAroundTile(tile: tile)
            if numberOfSelectedAround == 2 {
                if tile.isSelected {
                    let cell = Cell()
                    cell.x = tile.x
                    cell.z = tile.z
                    boxes.append(cell)
                } else {
//                    tile.isSelected = false
                }
            } else if numberOfSelectedAround == 3 {
                let cell = Cell()
                cell.x = tile.x
                cell.z = tile.z
                boxes.append(cell)
//                tile.isSelected = true
            } else {
//                tile.isSelected = false
            }
        }
        setSelection()
        return boxes
    }
    
    func checkNumberOfBoxesAroundTile(tile: Tile) -> Int {
        var count = 0
        
        if checkSelectionTile(x: (tile.x ?? -10) + 1, z: (tile.z ?? -10) - 1) {
            count += 1 }
        if checkSelectionTile(x: (tile.x ?? -10) + 1, z: (tile.z ?? -10)) {
            count += 1 }
        if checkSelectionTile(x: (tile.x ?? -10) + 1, z: (tile.z ?? -10) + 1) {
            count += 1 }
        if checkSelectionTile(x: (tile.x ?? -10), z: (tile.z ?? -10) - 1) {
            count += 1 }
        if checkSelectionTile(x: (tile.x ?? -10), z: (tile.z ?? -10) + 1) {
            count += 1 }
        if checkSelectionTile(x: (tile.x ?? -10) - 1, z: (tile.z ?? -10) - 1) {
            count += 1 }
        if checkSelectionTile(x: (tile.x ?? -10) - 1, z: (tile.z ?? -10)) {
            count += 1 }
        if checkSelectionTile(x: (tile.x ?? -10) - 1, z: (tile.z ?? -10) + 1) {
            count += 1 }
        return count
    }
    
    func checkSelectionTile(x: Float, z: Float) -> Bool {
        if x >= 0, z >= 0 {
            let tile = tiles.first(where: { $0.x == x && $0.z == z })
            return tile?.isSelected ?? false
        }
        return false
    }
    
    func setSelection() {
        for tile in tiles {
            for node in gridNodes {
                if tile.x == node.position.x && tile.z == node.position.z {
                    tile.isSelected = true
                } else {
                    tile.isSelected = false
                }
            }
        }
    }
    
    func getGridNodes() -> [SCNNode] {
        return gridNodes
    }
}
