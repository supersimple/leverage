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
    @IBOutlet weak var referralCodeField: UITextField!
    
    @IBOutlet weak var showLocation: UISwitch!
    @IBOutlet weak var showTeam: UISwitch!
    @IBOutlet weak var showCommitment: UISwitch!
    
    @IBOutlet weak var applyButton: UIButton!
    @IBAction func applyButton(sender: AnyObject) {
        //save the settings to userDefaults
        
        if(guidField.text!.isEmpty){
            guidField.text = self.defaultGuid;
        }
        if(apikeyField.text!.isEmpty){
            apikeyField.text = self.defaultApi;
        }
        if(referralCodeField.text!.isEmpty){
            referralCodeField.text = "";
        }
        
        userDefaults.setObject(guidField.text, forKey: "lever_url")
        userDefaults.setObject(apikeyField.text, forKey: "lever_api_key")
        userDefaults.setObject(referralCodeField.text, forKey: "lever_referral_code")
        userDefaults.setObject(showLocation.on, forKey: "list_location")
        userDefaults.setObject(showTeam.on, forKey: "list_team")
        userDefaults.setObject(showCommitment.on, forKey: "list_commitment")
        //self.performSegueWithIdentifier("showInitialJobsList", sender: nil)
        //self.dismissViewControllerAnimated(true, completion: {}); //modal presentation only
    }
    
    let userDefaults = NSUserDefaults.standardUserDefaults();
    let defaultGuid: String = "leverdemo";
    let defaultApi: String = "5ac21346-8e0c-4494-8e7a-3eb92ff77902"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings:SettingsHelper = SettingsHelper() //this is how you init an object
        
        //setup the values of each form element
        self.guidField.text         = settings.userSettingExists("lever_url") ? userDefaults.valueForKey("lever_url") as! String : defaultGuid
        self.apikeyField.text       = settings.userSettingExists("lever_api_key") ? userDefaults.valueForKey("lever_api_key") as! String : defaultApi
        self.referralCodeField.text = settings.userSettingExists("lever_referral_code") ? userDefaults.valueForKey("lever_referral_code") as! String : ""
        self.showLocation.on        = settings.userSettingExists("list_location") ? userDefaults.valueForKey("list_location") as! Bool : true
        self.showTeam.on            = settings.userSettingExists("list_team") ? userDefaults.valueForKey("list_team") as! Bool : true
        self.showCommitment.on      = settings.userSettingExists("list_commitment") ? userDefaults.valueForKey("list_commitment") as! Bool : true
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


