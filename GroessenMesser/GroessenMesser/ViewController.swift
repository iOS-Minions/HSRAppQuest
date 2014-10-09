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
    func camViewControllerDidMeasureAngles(controller:PhotoView,first:Double,second:Double);
}

class ViewController: UIViewController, CameraViewControllerDelegate {
    
    var previewLayer : AVCaptureVideoPreviewLayer?

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
    
    func camViewControllerDidMeasureAngles(controller: PhotoView, first: Double, second: Double) {
        //TODO update UI
        winkelA.text = toString(12.012)
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

