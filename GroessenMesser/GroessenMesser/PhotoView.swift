//
//  PhotoView.swift
//  GroessenMesser
//
//  Created by Marcel Hess on 07.10.14.
//  Copyright (c) 2014 Marcel Hess. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class PhotoView: UIViewController {
    
    @IBOutlet var pointerBottom: UIImageView!
    @IBOutlet var pointer1: UIImageView!
    @IBOutlet var pointer2: UIImageView!
    
    
    var winkelA = 361.0
    var winkelB = 361.0
    var currentMotion = 361.0
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var delegate:CameraViewControllerDelegate?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    
    
    let motionManager = CMMotionManager()
    var currentAngle:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        println("Capture device found")
                        beginSession()
                    }
                }
            }
        }
        
            
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: { (motion, error) -> Void in
            let interfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
            if UIInterfaceOrientationIsPortrait(interfaceOrientation) {
                // horizontales wenden
                self.currentMotion = self.radiansToDegree(motion.attitude.pitch)
            } else {
                // Querformat wird eig nicht von der App unterstützt aber falls das ändert:
                self.currentMotion = self.radiansToDegree(motion.attitude.roll)
            }
            
            println("hallo1 \(self.currentMotion)")
            // der Wendepunkt startet bei 90c - senkrechtes handy
            // kippt man es zurück, gehen die Zahlen zurück
            
            // iPhone ist geneigt nach vorne
            var roll = self.radiansToDegree(motion.attitude.roll)
            if ((roll < 60) && (roll > -60)){
                
            } else {
                self.currentMotion = 180 + self.currentMotion
            }
            // die opere Kante ist also die grössere Zahl
            // die Rechnung ergibt "oben - unten = winkel a"
            
        })
     
    }
    
    func radiansToDegree(radians:Double) -> Double {
        return radians * 180 / M_PI
    }
    
    func focusTo(value : Float) {
        if let device = captureDevice {
            if(device.lockForConfiguration(nil)) {
                device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
                    //
                })
                device.unlockForConfiguration()
            }
        }
        
        takeData()
        
    }
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var anyTouch = touches.anyObject() as UITouch
        var touchPercent = anyTouch.locationInView(self.view).x / screenWidth
        focusTo(Float(touchPercent))
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var anyTouch = touches.anyObject() as UITouch
        var touchPercent = anyTouch.locationInView(self.view).x / screenWidth
        focusTo(Float(touchPercent))
    }
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
        
    }
    
    func beginSession() {
        
        configureDevice()
        
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        bringObjectsInFront()
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
    func bringObjectsInFront() {
        self.view.bringSubviewToFront(pointerBottom)
        self.view.bringSubviewToFront(pointer1)
        self.view.bringSubviewToFront(pointer2)
    }
    
    //Und dann sobald die Messung gemacht wurde:
    @IBAction func measurementDone(sender: UIButton) {
        var winkelBeta = winkelA - winkelB
        delegate?.camViewControllerDidMeasureAngles(self, beta: winkelBeta)
    }
    
    func takeData() {
        
        if (winkelA < 361) {
            winkelB = currentMotion
        } else {
            winkelA = currentMotion
        }
        
        if (winkelA < 361 && winkelB < 361) {
            var winkelBeta = winkelA - winkelB
            delegate?.camViewControllerDidMeasureAngles(self, beta: winkelBeta)
            // go back
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
}
