
//
//  ErrorViewController.swift
//  Leverage
//
//  Created by Todd Resudek on 7/13/15.
//  Copyright (c) 2015 supersimple. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: Selector("prepareToReturnToPrevious"), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareToReturnToPrevious(){
        self.dismissViewControllerAnimated(true, completion: {});
    }
}