//
//  ThankYouController.swift
//  Leverage
//
//  Created by Todd Resudek on 7/13/15.
//  Copyright (c) 2015 supersimple. All rights reserved.
//

import UIKit

class ThankYouController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: Selector("prepareToReturnToFirst"), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareToReturnToFirst(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.returnToFirst()
    }
}

