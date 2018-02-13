//
//  ViewController.swift
//  D06
//
//  Created by Siva NADARASSIN on 1/17/18.
//  Copyright © 2018 Siva NADARASSIN. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var itemBehaviour: UIDynamicItemBehavior!
    let motionManager = CMMotionManager()
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        print("tap en position \(sender.location(in: view))")
        let shape = Shape(point: sender.location(in: view),
                          maxwidth: self.view.bounds.width,
                          maxheight: self.view.bounds.height)
        view.addSubview(shape)
        gravity.addItem(shape)
        collision.addItem(shape)
        itemBehaviour.addItem(shape)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture:)))
        shape.addGestureRecognizer(gesture)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(recognizer:)))
        shape.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(recognizer:)))
        shape.addGestureRecognizer(rotate)
    }
    @objc func panGesture (gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("Began")
            self.gravity.removeItem(gesture.view!)
            // --- gesture.view?.center = gesture.location(in: gesture.view?.superview)
        case .changed:
            print("Changed to \(gesture.location(in: view))")
            gesture.view?.center = gesture.location(in: gesture.view?.superview)
            animator.updateItem(usingCurrentState: gesture.view!)
        case .ended:
            print("Ended")
            self.gravity.addItem(gesture.view!)
        case .failed, .cancelled:
            print("Failed or Cancelled")
        case .possible:
            print("Possible")
        }
    }
    @objc func handlePinch(recognizer : UIPinchGestureRecognizer) {
        print("handlePinch")
        if let view = recognizer.view {
            print(recognizer.scale)
            
            switch recognizer.state {
            case .began:
                print("Began")
                self.gravity.removeItem(view)
                self.collision.removeItem(view)
                self.itemBehaviour.removeItem(view)
                
            case.changed:
                print("Changed")
                recognizer.view?.layer.bounds.size.height *= recognizer.scale
                recognizer.view?.layer.bounds.size.width *= recognizer.scale
                if let tmp = recognizer.view! as? Shape {
                    if (tmp.isCircle) {recognizer.view!.layer.cornerRadius *= recognizer.scale}}
                
                 view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
                 animator.updateItem(usingCurrentState: recognizer.view!)
                
                recognizer.scale = 1
                
            case .ended:
                print("Ended")
                self.gravity.addItem(view)
                self.collision.addItem(view)
                self.itemBehaviour.addItem(view)
                
                
            case .failed, .cancelled:
                print("Failed or Cancelled")
            case .possible:
                print("Possible")
            }
        }
    }
    @objc func handleRotate(recognizer : UIRotationGestureRecognizer) {
        print("handleRotate")
        if let view = recognizer.view {
            print(recognizer.rotation)
            switch recognizer.state {
            case .began:
                print("Began")
                self.gravity.removeItem(view)
                
            case.changed:
                print("Changed")
                
                view.transform = view.transform.rotated(by: recognizer.rotation)
                animator.updateItem(usingCurrentState: recognizer.view!)
                recognizer.rotation = 0
            case .ended:
                print("Ended")
                self.gravity.addItem(view)
            case .failed, .cancelled:
                print("Failed or Cancelled")
            case .possible:
                print("Possible")
            }
        }
    }
    // --- cette fonction utilise les donnees de l'acceleromètre
    //     pour changer la direction de la gravité
    
    func accelerometerHandler(data: CMAccelerometerData?, error: Error?) {
        print("accelerometerHandler")
        
        if let myData = data {
            let x = CGFloat(myData.acceleration.x);
            let y = CGFloat(myData.acceleration.y);
            print("x = \(x), y = \(y)")
            let v = CGVector(dx: x, dy: -y);
            gravity.gravityDirection = v;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // --- Do any additional setup after loading the view, typically from a nib.
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [])
        animator.addBehavior(gravity)
        
        
        collision = UICollisionBehavior(items: [])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        itemBehaviour = UIDynamicItemBehavior(items: [])
        itemBehaviour.elasticity = 0.9
        animator.addBehavior(itemBehaviour)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1
            let queue = OperationQueue.main
            
            // --- toutes les secondes, appel de la fonction accHandler
            motionManager.startAccelerometerUpdates(to: queue, withHandler: accelerometerHandler )
        }
        else {
            print("desolé, ce device ne possede pas d'acceleromètre !")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        
        super.viewWillDisappear(animated)
        if motionManager.isAccelerometerAvailable {
            // --- liberation de la main queue
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // --- Dispose of any resources that can be recreated.
    }
    
    
}
