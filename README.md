# WJBarCodeScanner

If you only want to scan a barCode without dig into AVFoundtion,this is a good tool for you.    
The WJBarCodeScanner keeps the scan process as simple as possible,and give you as much flexible as possible.

#ScreenShot
![image](https://github.com/wj2061/WJBarCodeScanner/blob/master/Screenshot/001.jpg)

# QuickExample
1.Create a subclass of  WJScanViewController.    
2.Configure transparentArea,scanColor,metadataObjectTypes .    
3.Override `func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)`
  to get the result of scanning.    
4.Override `func handleCameraWithoutAuth()` to handle cases when there is no camera available.    
5.Use proterties （`session` `output`） to do more specific staff.    

```swift
import UIKit
import AVFoundation

class ViewController: WJScanViewController{
    @IBOutlet weak var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        transparentArea = CGRect(x: view.center.x-150, y: 0, width: 300, height: 400)
        scanColor = UIColor.cyanColor()
        metadataObjectTypes = [ AVMetadataObjectTypeQRCode]  // IF YOU only want to scan QRCode
    }

    override func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if  let metadataObject = metadataObjects.first {
            let stringValue = (metadataObject as! AVMetadataMachineReadableCodeObject).stringValue
            print(stringValue)
            messageLabel.text = stringValue
            session.stopRunning()
        }
    }
    
    override func handleCameraWithoutAuth() {
        let alertView = UIAlertController(title: "alert", message: "Cannot use Back Camera", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil ))
        presentViewController(alertView, animated: true , completion: nil)
    }
}
```

# how to install

## 1 manual
step1: Drop WJBarCodeScanner folder into your project.

step2: Create a subclass of  WJScanViewController. 
``` swift
import UIKit
import AVFoundation

class ViewController: WJScanViewController{
}
```
## 2 cocoapods
 step1:add the following line to your Podfile:    
````
platform :ios, '8.0'
use_frameworks!
pod 'WJBarCodeScanner'
````

  step2:import WJBarCodeScanner
````swift
import WJBarCodeScanner
````







