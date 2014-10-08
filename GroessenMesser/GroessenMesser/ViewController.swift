//
//  ViewController.swift
//  GroessenMesser
//
//  Created by Marcel Hess on 29.09.14.
//  Copyright (c) 2014 Marcel Hess. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var previewLayer : AVCaptureVideoPreviewLayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

}

