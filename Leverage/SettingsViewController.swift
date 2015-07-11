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
    
    @IBOutlet weak var showLocation: UISwitch!
    @IBOutlet weak var showTeam: UISwitch!
    @IBOutlet weak var showCommitment: UISwitch!
    
    @IBOutlet weak var applyButton: UIButton!
    @IBAction func applyButton(sender: AnyObject) {
        //save the settings to userDefaults
        
        if(guidField.text.isEmpty){
            guidField.text = self.defaultGuid;
        }
        if(apikeyField.text.isEmpty){
            apikeyField.text = self.defaultApi;
        }
        
        userDefaults.setObject(guidField.text, forKey: "lever_url")
        userDefaults.setObject(apikeyField.text, forKey: "lever_api_key")
        userDefaults.setObject(showLocation.on, forKey: "list_location")
        userDefaults.setObject(showTeam.on, forKey: "list_team")
        userDefaults.setObject(showCommitment.on, forKey: "list_commitment")
        self.performSegueWithIdentifier("showInitialJobsList", sender: nil)
    }
    
    let userDefaults = NSUserDefaults.standardUserDefaults();
    let defaultGuid: String = "leverdemo";
    let defaultApi: String = "5ac21346-8e0c-4494-8e7a-3eb92ff77902"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        applyButton.layer.cornerRadius = 3
        applyButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


