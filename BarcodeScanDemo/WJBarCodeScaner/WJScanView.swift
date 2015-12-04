//
//  WJScanView.swift
//  BarcodeScanDemo
//
//  Created by WJ on 15/12/4.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
let kScanLineAnimateDuration:NSTimeInterval = 0.02

class WJScanView: UIView {
    var transparentArea = CGRect()
    
    var scanImage = UIImage(named: "scan_line")!
    private var scanLine  = UIImageView()
    var showScanLine = true
    var scanColor = UIColor.redColor()
    var timer : NSTimer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
       super.layoutSubviews()
        if showScanLine{
            initScanLine()
            timer = NSTimer.scheduledTimerWithTimeInterval(kScanLineAnimateDuration,
                                                           target: self,
                                                           selector: "scan",
                                                           userInfo: nil,
                                                           repeats: true)
        }
    }
    
    func initScanLine(){
        scanLine.frame = CGRectMake(transparentArea.origin.x,
                                    transparentArea.origin.y,
                                    transparentArea.width,
                                    2)
        scanLine.contentMode = .ScaleAspectFill
        scanLine.image       = scanImage.imageWithRenderingMode(.AlwaysTemplate)
        scanLine.tintColor   = scanColor
        self.addSubview(scanLine)
    }
    
    func scan(){
        print("scan")
        UIView.animateWithDuration(kScanLineAnimateDuration, animations: { () -> Void in
            var point = self.scanLine.center
            if CGRectContainsRect(self.transparentArea, self.scanLine.frame){
               point.y++
            }else {
                point.y = CGRectGetMinY(self.transparentArea) + 1
            }
            self.scanLine.center = point
        })
    }
    
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextSetRGBFillColor(ctx, 40/255.0, 40/255.0, 40/255.0, 0.5)
        CGContextFillRect(ctx, bounds)  //dim background
        
        CGContextClearRect(ctx, transparentArea)  // clear transparentArea
        
        let path = UIBezierPath(rect: transparentArea)
        path.lineWidth = 0.8
        UIColor.whiteColor().setStroke()
        path.stroke()
    }
    
    
    
    


}
