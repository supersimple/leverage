//
//  SettingsViewController.swift
//  Leverage
//
//  Created by Todd Resudek on 6/18/15.
//  Copyright (c) 2015 supersimple. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var guidField: UITextField!
    @IBOutlet weak var apikeyField: UITextField!
    
    @IBOutlet weak var applyButton: UIButton!
    @IBAction func applyButton(sender: AnyObject) {
        
    }
    
    let userDefaults = NSUserDefaults.standardUserDefaults();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyButton.layer.cornerRadius = 3
        applyButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)
        
        println(userDefaults.valueForKey("lever_url"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


