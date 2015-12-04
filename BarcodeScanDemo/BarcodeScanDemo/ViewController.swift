//
//  ViewController.swift
//  BarcodeScanDemo
//
//  Created by WJ on 15/12/4.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
//    let scView = WJScanView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let scView = WJScanView(frame:view.bounds)
        scView.transparentArea = CGRectMake(100, 100, 200, 200)
        
        view.addSubview(scView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

