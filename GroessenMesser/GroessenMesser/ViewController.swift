//
//  ViewController.swift
//  GroessenMesser
//
//  Created by Marcel Hess on 29.09.14.
//  Copyright (c) 2014 Marcel Hess. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate {
    func camViewControllerDidMeasureAngles(controller:PhotoView,beta:Double);
}

class ViewController: UIViewController, CameraViewControllerDelegate {
    
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var wA = 0
    var wB = 0
    var sA = 0
    var sB = 0

    @IBOutlet var winkelA: UITextField!
    @IBOutlet var winkelB: UITextField!
    @IBOutlet var streckeA: UITextField!
    @IBOutlet var streckeB: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as PhotoView
        destinationViewController.delegate = self
    }
    
    func camViewControllerDidMeasureAngles(controller: PhotoView, beta: Double) {
        //TODO update UI
        wB = Int(beta)
        winkelB.text = toString(wB)
    }
    
    func rechne() {
        
    }
    
    @IBAction func pos1(sender: UIButton) {
        
        var position = "pos1"
        
        //self.navigationController?.popToViewController(PhotoView(), animated: true)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var setViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PhotoView") as PhotoView
        self.navigationController?.popToViewController(setViewController, animated: false)

        
    }
    
    @IBAction func pos2(sender: UIButton) {
        
        var position = "pos2"
        
    }
    
    
    @IBAction func unwindFromPhotoView(unwindSegue:UIStoryboardSegue) {
        let sourceViewController = unwindSegue.sourceViewController as PhotoView
        winkelA.text = toString(sourceViewController.winkelA)
    }

}

