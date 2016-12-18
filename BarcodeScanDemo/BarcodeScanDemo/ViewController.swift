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
        transparentArea     = CGRect(x: view.center.x-100, y: view.center.y-200, width: 200, height: 200)
        scanColor           = UIColor.red
        metadataObjectTypes = [ AVMetadataObjectTypeQRCode ]  // IF YOU only want to scan QRCode
    }

    override func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if  let metadataObject = metadataObjects.first {
            if let stringValue = (metadataObject as! AVMetadataMachineReadableCodeObject).stringValue{
                print(stringValue)
                messageLabel.text = stringValue
            }
        }
    }
    
    override func handleCameraWithoutAuth() {
        let alertView = UIAlertController(title: "alert", message: "Cannot use Back Camera", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil ))
        present(alertView, animated: true , completion: nil)
    }
}

