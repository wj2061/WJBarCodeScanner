//
//  WJScanView.swift
//  BarcodeScanDemo
//
//  Created by WJ on 15/12/4.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
let kScanLineAnimateDuration:TimeInterval = 0.02
let kCornerStrokelength:CGFloat             = 15

class WJScanView: UIView {
    public var transparentArea = CGRect(){//area to be scanned
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    public var isShowScanLine = true
    
    public var scanColor = UIColor.green{//scanLine's color
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    fileprivate var timer : Timer?
    fileprivate var scanLine  = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    deinit{
        timer?.invalidate()
        timer = nil
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isShowScanLine{
            initScanLine()
            weak var weakSelf = self
            timer = Timer.scheduledTimer(timeInterval: kScanLineAnimateDuration,
                                         target: weakSelf!,
                                         selector: #selector(WJScanView.scan),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    fileprivate func initScanLine(){
        scanLine.frame = CGRect(x: transparentArea.origin.x,
                                    y: transparentArea.origin.y,
                                    width: transparentArea.width,
                                    height: 2)
        scanLine.contentMode = .scaleAspectFill
        
        let scanImage        = UIImage(named: "WJScanLine")!
        scanLine.image       = scanImage.withRenderingMode(.alwaysTemplate)
        scanLine.tintColor   = scanColor
        self.addSubview(scanLine)
    }
    
    func scan(){
        UIView.animate(withDuration: kScanLineAnimateDuration, animations: { () -> Void in
            var point = self.scanLine.center
            if self.transparentArea.contains(self.scanLine.frame){
               point.y += 1
            }else {
                point.y = self.transparentArea.minY + 1
            }
            self.scanLine.center = point
        })
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.setFillColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 0.5)
        ctx?.fill(bounds)  //dim background
        
        ctx?.clear(transparentArea)  // clear transparentArea
        
        let path = UIBezierPath(rect: transparentArea)
        path.lineWidth = 1
        UIColor.white.setStroke()
        path.stroke()
        
        addCornerLineWithContext(ctx!, rect: transparentArea)
    }
    
    fileprivate func addCornerLineWithContext(_ ctx:CGContext,rect:CGRect){
        ctx.setLineWidth(2)
        let components = scanColor.cgColor.components
        ctx.setStrokeColor(red: (components?[0])!, green: (components?[1])!, blue: (components?[2])!, alpha: (components?[3])!)
        
        let upLreftPoints = [CGPoint(x: rect.origin.x, y: rect.origin.y+kCornerStrokelength),
                             rect.origin,
                             CGPoint(x: rect.origin.x+kCornerStrokelength, y: rect.origin.y)]
        ctx.addLines(between:upLreftPoints)
       
        let upRightPoint = CGPoint(x: rect.maxX, y: rect.origin.y)
        let upRightPoints = [CGPoint(x: upRightPoint.x-kCornerStrokelength, y: upRightPoint.y),
                             upRightPoint,
                             CGPoint(x: upRightPoint.x, y: upRightPoint.y+kCornerStrokelength)]
        ctx.addLines(between:upRightPoints);
        
        let downLeftPoint = CGPoint(x: rect.origin.x, y: rect.maxY)
        let downLeftPoints = [CGPoint(x: downLeftPoint.x, y: downLeftPoint.y-kCornerStrokelength),
                              downLeftPoint,
                              CGPoint(x: downLeftPoint.x+kCornerStrokelength, y: downLeftPoint.y)]
        ctx.addLines(between:downLeftPoints);
        
        let downRightPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let downRightPoints = [CGPoint(x: downRightPoint.x-kCornerStrokelength, y: downRightPoint.y),
                               downRightPoint,
                               CGPoint(x: downRightPoint.x, y: downRightPoint.y-kCornerStrokelength)]
        ctx.addLines(between:downRightPoints);
        
        ctx.strokePath()
    }
}
