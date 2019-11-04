//
//  GameViewController.swift
//  GameOfLife
//
//  Created by Felipe Petersen on 31/10/19.
//  Copyright © 2019 Felipe Petersen. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    let scene = SCNScene()
    lazy var sceneView = self.view as! SCNView
    var nodesAdded = [SCNNode]()
    var grid = GridModel()
    var shouldStart = false
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sceneView.delegate = self
//        sceneView.isPlaying = true
        setupSquare()
        removeButton()
        startButton()
    }
    
    func setupSquare() {
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 5, y: 20, z: 20)
        let lookNode = SCNNode()
        lookNode.position = SCNVector3(x: 2, y: 2, z: 0.5)
        let lookConstraint = SCNLookAtConstraint(target: lookNode)
        cameraNode.constraints = [lookConstraint]
        
        // create and add a light to the scene
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light!.type = .omni
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        scene.rootNode.addChildNode(lightNode)
        sceneView.autoenablesDefaultLighting = true
        
        // allows the user to manipulate the camera
        sceneView.allowsCameraControl = true
        
//        sceneView.showsStatistics = true
        sceneView.scene = scene
        
        let gridNodes = self.grid.getGridNodes()
        for node in gridNodes {
            self.scene.rootNode.addChildNode(node)
        }
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    func setupGrid() {
    }

    func removeButton() {
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        let btn = UIButton()
        btn.setTitle("Stop", for: .normal)
        btn.frame = CGRect(x: viewWidth/2 - 25, y: 100, width: 50, height: 50)
        btn.backgroundColor = .blue
        sceneView.addSubview(btn)
        btn.addTarget(self, action: #selector(didTapRemove), for: .touchDown)
//        btn.addTarget(forAction: , withSender: self)
    }
    
    func startButton() {
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        let btn = UIButton()
        btn.setTitle("Start", for: .normal)
        btn.frame = CGRect(x: viewWidth/2 - 25, y: viewHeight - 100, width: 50, height: 50)
        btn.backgroundColor = .green
        sceneView.addSubview(btn)
        btn.addTarget(self, action: #selector(didTapStart), for: .touchDown)
        //        btn.addTarget(forAction: , withSender: self)
    }
    
    @objc func didTapRemove() {
        timer.invalidate()
    }
    
    @objc func didTapStart() {
        timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(start), userInfo: nil, repeats: true)
    }
    
    @objc func start() {
        
        for node in self.nodesAdded {
            node.removeFromParentNode()
        }
        self.nodesAdded.removeAll()
        let boxes = self.grid.getNewBoxes()
        for result in boxes {
            let box = self.grid.setBoxToPosition(x: result.x ?? -1, y: 0.5, z: result.z ?? -1)
            if let box = box {
                self.nodesAdded.append(box)
                self.scene.rootNode.addChildNode(box)
            }
            
        }
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            let box = grid.setBoxToPosition(x: result.node.position.x, y: 0.5, z: result.node.position.z)
            if let box = box {
                self.nodesAdded.append(box)
                scene.rootNode.addChildNode(box)
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
