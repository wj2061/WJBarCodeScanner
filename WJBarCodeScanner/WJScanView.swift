//
//  WJScanView.swift
//  BarcodeScanDemo
//
//  Created by WJ on 15/12/4.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
let kScanLineAnimateDuration:NSTimeInterval = 0.02
let kCornerStrokelength:CGFloat             = 15

class WJScanView: UIView {
    var transparentArea = CGRect(){
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var showScanLine = true
    var scanColor = UIColor.redColor(){
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    private var timer : NSTimer?
    private var scanLine  = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
    }
    
    deinit{
        timer?.invalidate()
        timer = nil
    }
    
    
    override func layoutSubviews() {
       super.layoutSubviews()
        if showScanLine{
            initScanLine()
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(kScanLineAnimateDuration,
                                                           target: self,
                                                           selector: "scan",
                                                           userInfo: nil,
                                                           repeats: true)
        }
    }
    
    private func initScanLine(){
        scanLine.frame = CGRectMake(transparentArea.origin.x,
                                    transparentArea.origin.y,
                                    transparentArea.width,
                                    2)
        scanLine.contentMode = .ScaleAspectFill
        
        let scanImage        = UIImage(named: "WJScanLine")!
        scanLine.image       = scanImage.imageWithRenderingMode(.AlwaysTemplate)
        scanLine.tintColor   = scanColor
        self.addSubview(scanLine)
    }
    
    func scan(){
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
        path.lineWidth = 1
        UIColor.whiteColor().setStroke()
        path.stroke()
        
        addCornerLineWithContext(ctx!, rect: transparentArea)
    }
    
    private func addCornerLineWithContext(ctx:CGContextRef,rect:CGRect){
        CGContextSetLineWidth(ctx, 2)
        let components = CGColorGetComponents(scanColor.CGColor)
        CGContextSetRGBStrokeColor(ctx,  components[0], components[1], components[2], components[3])
        
        let upLreftPoints = [CGPointMake(rect.origin.x, rect.origin.y+kCornerStrokelength),
                             rect.origin,
                             CGPointMake(rect.origin.x+kCornerStrokelength, rect.origin.y)]
        CGContextAddLines(ctx, upLreftPoints, 3)
       
        let upRightPoint = CGPointMake(CGRectGetMaxX(rect), rect.origin.y)
        let upRightPoints = [CGPointMake(upRightPoint.x-kCornerStrokelength, upRightPoint.y),
                             upRightPoint,
                             CGPointMake(upRightPoint.x, upRightPoint.y+kCornerStrokelength)]
        CGContextAddLines(ctx, upRightPoints, 3)
        
        let downLeftPoint = CGPointMake(rect.origin.x, CGRectGetMaxY(rect))
        let downLeftPoints = [CGPointMake(downLeftPoint.x, downLeftPoint.y-kCornerStrokelength),
                              downLeftPoint,
                              CGPointMake(downLeftPoint.x+kCornerStrokelength, downLeftPoint.y)]
        CGContextAddLines(ctx, downLeftPoints, 3)
        
        let downRightPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        let downRightPoints = [CGPointMake(downRightPoint.x-kCornerStrokelength, downRightPoint.y),
                               downRightPoint,
                               CGPointMake(downRightPoint.x, downRightPoint.y-kCornerStrokelength)]
        CGContextAddLines(ctx, downRightPoints, 3)
        
        CGContextStrokePath(ctx)
    }
}
