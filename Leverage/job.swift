//
//  job.swift
//  Leverage
//
//  Created by Todd Resudek on 6/17/15.
//  Copyright (c) 2015 supersimple. All rights reserved.
//

import Foundation

class Job {
    
    var hostedUrl: NSString = ""
    var uuid: NSString = ""
    var lists: NSArray = []
    var applyUrl: NSString = ""
    var categories: NSDictionary = [:]
    var text: NSString = ""
    var description: NSString = ""
    var additional: NSString = ""
    var createdAt: NSDate = NSDate()
    
    init(properties: NSDictionary) {
        self.hostedUrl = properties["hostedUrl"] as! NSString;
        self.uuid = properties["id"] as! NSString;
        self.lists = properties["lists"] as! NSArray;
        self.applyUrl = properties["applyUrl"] as! NSString;
        self.categories = properties["categories"] as! NSDictionary;
        self.text = properties["text"] as! NSString;
        self.description = checkForNil(properties,k: "description") as NSString!
        self.additional = properties.objectForKey("additional") != nil ? properties["additional"] as! NSString : "" as NSString;
        self.createdAt = NSDate(timeIntervalSince1970:properties["createdAt"] as! NSTimeInterval);
        
    }
    
    private func checkForNil(dict: NSDictionary, k: String) -> NSString{
       if let _: AnyObject = dict[k]{
           return dict[k] as! NSString
       }else{
           return ""
       }
    }
    
}