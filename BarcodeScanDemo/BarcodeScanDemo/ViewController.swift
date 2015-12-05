//
//  ViewController.swift
//  BarcodeScanDemo
//
//  Created by WJ on 15/12/4.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: WJScanViewController{
    @IBOutlet weak var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        transparentArea = CGRect(x: view.center.x-150, y: 0, width: 300, height: 400)
        scanColor = UIColor.cyanColor()
//        metadataObjectTypes = [ AVMetadataObjectTypeQRCode]  // IF YOU only want to scan QRCode
        
        
    }

    override func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        print("22")
        if  let metadataObject = metadataObjects.first {
            let stringValue = (metadataObject as! AVMetadataMachineReadableCodeObject).stringValue
            print(stringValue)
            messageLabel.text = stringValue
            //            session.stopRunning()

        }
    }
    
    override func handleCameraWithoutAuth() {
        let alertView = UIAlertController(title: "alert", message: "Cannot use Back Camera", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil ))
        presentViewController(alertView, animated: true , completion: nil)
    }

}

