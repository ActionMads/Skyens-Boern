//
//  ViewController.swift
//  Skyens_Boern
//
//  Created by Mads Munk on 26/08/2022.
//  Copyright © 2022 Mads Munk. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation
import SpriteKit
import GameplayKit

class ViewController : UIViewController, UIGestureRecognizerDelegate {
    
    weak var scene : Scene?
    weak var previusScene : Scene? = nil
    let sceneSize : CGSize = CGSize(width: 2732, height: 2048)
    var isFirst : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectScene(selectedScene: HomeScene(size: sceneSize))
    }
    
    func selectGKScene(sceneName : String){
        
        if let scene = GKScene(fileNamed: sceneName) {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! Scene?{
                
                // Copy gameplay related content over to the scene
                sceneNode.withCamera = true
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                sceneNode.viewController = self
                


                // Present the scene
                if let view = self.view as! SKView? {
                    let transition = SKTransition.crossFade(withDuration: 3.0)
                    view.presentScene(sceneNode, transition: transition)
                    view.preferredFramesPerSecond = 30
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.showsPhysics = false
                    view.showsDrawCount = true
                }
                sceneNode.panRecogniser.delegate = self
                sceneNode.clickRecognizer.delegate = self
                sceneNode.rotationRecogniser.delegate = self
            }
        }
    }
    
    func selectScene(selectedScene : Scene) {
        scene = selectedScene
            
            // Set the scale mode to scale to fit the window
        scene?.scaleMode = .aspectFit
        scene?.viewController = self
        scene?.withCamera = false
        
        // Present the scene
        if let view = self.view as! SKView? {
            let transition = SKTransition.crossFade(withDuration: 3.0)
            view.presentScene(scene!, transition: transition)
            
            view.ignoresSiblingOrder = true
            view.preferredFramesPerSecond = 30
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
            view.ignoresSiblingOrder = true
            view.showsDrawCount = true
        }
        scene?.panRecogniser.delegate = self
        scene?.clickRecognizer.delegate = self
        scene?.rotationRecogniser.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if (gestureRecognizer == scene?.panRecogniser || gestureRecognizer == scene?.rotationRecogniser) && otherGestureRecognizer == scene?.clickRecognizer {
            return true
        }
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var shouldAutorotate: Bool {
            return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
