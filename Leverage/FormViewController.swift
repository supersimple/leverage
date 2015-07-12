//
//  FormViewController.swift
//  Leverage
//
//  Created by Todd Resudek on 6/17/15.
//  Copyright (c) 2015 supersimple. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    
    @IBOutlet weak var backToDetailButton: UIButton!
    
    var description_url: String = ""; //passed in via segue
    let urlPath: String = "https://api.lever.co/v0/postings/"
    let responseMode = "json"
    var selected_job_guid: String = "";
    var request_path: String = ""
    var lever_url: String = ""
    var lever_api_key: String = ""
    
    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phonenumberField: UITextField!
    @IBOutlet weak var resumeField: UITextField!
    @IBOutlet weak var commentsField: UITextView!
    
    @IBOutlet weak var applyButton: UIButton!
    @IBAction func applyButton(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backToDetailButton.layer.cornerRadius = 3
        backToDetailButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)
        applyButton.layer.cornerRadius = 3
        applyButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)
        applyBorders(fullnameField);
        applyBorders(emailField);
        applyBorders(phonenumberField);
        applyBorders(resumeField);
        applyBorders(commentsField);
    }
    
    private func applyBorders(btn: AnyObject){
        btn.layer.cornerRadius = 3.0
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor( red: 200/255, green: 200/255, blue:200/255, alpha: 1.0 ).CGColor
        btn.layer.borderWidth = 1.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = NSUserDefaults.standardUserDefaults();
        
        self.lever_url = userDefaults.valueForKey("lever_url") as! String
        self.lever_api_key = userDefaults.valueForKey("lever_api_key") as! String
        self.request_path = self.urlPath + self.lever_url + "?mode=" + self.responseMode;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "backToJobDetail") {
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.selected_job_guid = self.selected_job_guid;
            detailViewController.description_url = self.description_url;
        }
    }
    
}
