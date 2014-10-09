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
    
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
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
        
        println("test")
        
        let motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.1
        
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue(),
            withHandler: {
                (motion, error) -> Void in
                //var pitch = motion.attitude.pitch }
                println("Pitch: \(motion.attitude.pitch)")
            })
        
     
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
        
        // go back
        //self.navigationController?.popToRootViewControllerAnimated(true)
        getPosition()
        
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
    
    func getPosition() {
        
        println("test2")
        
        let motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.1
        
        motionManager.startDeviceMotionUpdatesToQueue(
            NSOperationQueue.currentQueue(), withHandler: { (motion, error) -> Void in
                //var pitch = motion.attitude.pitch }
                println("Pitch: \(motion.attitude.pitch)") }
        )
        
        //var test = pitch
        
    }
    
}
