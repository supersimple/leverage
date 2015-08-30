//
//  Settings.swift
//  Leverage
//
//  Created by Todd Resudek on 8/29/15.
//  Copyright (c) 2015 supersimple. All rights reserved.
//

import UIKit

class SettingsHelper {
    
    let defaultApiKey = "5ac21346-8e0c-4494-8e7a-3eb92ff77902"
    let defaultUrl = "leverdemo";
    let urlPath: String = "https://api.lever.co/v0/postings/"
    let responseMode = "json"
    
    
    func userSettingExists(kUSERID: String) -> Bool {
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey(kUSERID) != nil) {
            return true
        }
        
        return false
    }
    
    
}