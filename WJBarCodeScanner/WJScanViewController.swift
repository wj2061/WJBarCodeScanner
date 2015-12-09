//
//  WJScanViewController.swift
//  BarcodeScanDemo
//
//  Created by wj on 15/12/4.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
import AVFoundation


@IBDesignable
public
class WJScanViewController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate{    
    
    public  let session = AVCaptureSession()
    public  let output = AVCaptureMetadataOutput()
    public  var input:AVCaptureDeviceInput?

    private var scanView :WJScanView?
    
    public  var metadataObjectTypes = [ AVMetadataObjectTypeUPCECode,
                                AVMetadataObjectTypeCode39Code,
                                AVMetadataObjectTypeCode39Mod43Code ,
                                AVMetadataObjectTypeEAN13Code ,
                                AVMetadataObjectTypeEAN8Code ,
                                AVMetadataObjectTypeCode93Code ,
                                AVMetadataObjectTypeCode128Code ,
                                AVMetadataObjectTypePDF417Code ,
                                AVMetadataObjectTypeQRCode ,
                                AVMetadataObjectTypeAztecCode ,
                                AVMetadataObjectTypeInterleaved2of5Code ,
                                AVMetadataObjectTypeITF14Code ,
                                AVMetadataObjectTypeDataMatrixCode        ]
        {
        didSet{
            output.metadataObjectTypes = metadataObjectTypes
        }
    }
    
    @IBInspectable
    public
    var scanColor:UIColor = UIColor.greenColor(){ didSet{  scanView?.scanColor = scanColor } }
    
    public
    var transparentArea = CGRectZero{
        didSet{
            print("disSet transparentArea to \(transparentArea)")
            scanView?.transparentArea = transparentArea
            output.rectOfInterest = CGRectMake(transparentArea.origin.y/view.frame.height,
                                               transparentArea.origin.x/view.frame.width,
                                               transparentArea.height/view.frame.height,
                                               transparentArea.width/view.frame.width)
        }
    }
    

    override public  func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do  {
            input = try AVCaptureDeviceInput(device: device)
        }catch let error as NSError{
            print("WJScanViewController : \n \(error.localizedDescription)")
            return
        }
        
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        session.sessionPreset = AVCaptureSessionPresetHigh
        session.addInput(input)
        session.addOutput(output)
        output.metadataObjectTypes = metadataObjectTypes

        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = AVLayerVideoGravityResize
        preview.frame = view.bounds
        view.layer.insertSublayer(preview, atIndex: 0)
        session.startRunning()
        
        scanView = WJScanView(frame: view.bounds)
        scanView!.scanColor = scanColor
        view.insertSubview(scanView!, atIndex: 1)
        
        //congifure transparentArea
        if transparentArea == CGRectZero{
            transparentArea = CGRect(x: view.center.x-100, y: view.center.y-100, width: 200, height: 200)
        }else{
            let rect = transparentArea
            transparentArea = rect
        }
    }
    
    override public func viewDidAppear(animated: Bool) {
        if input == nil{
            handleCameraWithoutAuth()
        }
    }
    
    //override in your subclass 
    public  func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        print("11")
        if  let metadataObject = metadataObjects.first {
            let stringValue = (metadataObject as! AVMetadataMachineReadableCodeObject).stringValue
            print(stringValue)
        }
    }
    
    //Lock Orientations to Portrait
    public  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    //access to camera denied
    public  func handleCameraWithoutAuth(){
        print("handleCameraWithoutAuth")
    }
    
    
}
