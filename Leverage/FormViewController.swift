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
    var lever_referral_code: String = ""
    
    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phonenumberField: UITextField!
    @IBOutlet weak var resumeField: UITextField!
    @IBOutlet weak var commentsField: UITextView!
    
    @IBAction func backToDetailButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var applyButton: UIButton!
    @IBAction func applyButton(sender: AnyObject) {
        let full_name_value = fullnameField.text;
        let email_address_value = emailField.text;
        let phone_number_value = phonenumberField.text;
        let resume_value = resumeField.text;
        let comments_value = commentsField.text;
        
        sendFormData(full_name_value, email_address_value: email_address_value, phone_number_value: phone_number_value, resume_value: resume_value, comments_value: comments_value);
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
    
    func update() {
        self.performSegueWithIdentifier("errorSegue", sender: nil)
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
        self.lever_referral_code = userDefaults.valueForKey("lever_referral_code") as! String
        self.request_path = self.urlPath + self.lever_url + "?mode=" + self.responseMode;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    private func sendFormData(full_name_value: NSString, email_address_value: NSString, phone_number_value: NSString, resume_value: NSString, comments_value: NSString) {
        // create the request & response
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.lever.co/v0/postings/\(self.lever_url)/\(self.lever_api_key)")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        var error: NSError?
        
        // create some JSON data and configure the request
        
        var bodyData = "name=\(full_name_value)&email=\(email_address_value)&phone=\(phone_number_value)&urls[LinkedIn]=\(resume_value)&comments=\(comments_value)"

        if(!self.lever_referral_code.isEmpty){
            bodyData = "socialReferralKey=" + self.lever_referral_code + "&" + bodyData
        }
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        //        let jsonString = "json=[{\"name\":\(full_name_value),\"email\":\(email_address_value)}]"
        //        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        print(request)
        
        do {
            // send the request
            try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        } catch let error1 as NSError {
            error = error1
        }
        
        // look at the response
        if let httpResponse = response as? NSHTTPURLResponse {
            print("HTTP response: \(httpResponse)")
            //move to thank you view
            self.performSegueWithIdentifier("thankYouSegue", sender: nil)
        } else {
            print("No HTTP response")
            //move to error view
            self.performSegueWithIdentifier("errorSegue", sender: nil)
        }
    }
    
    // Convert from NSData to json object
    private class func nsdataToJSON(data: NSData) -> AnyObject? {
        return try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
    }
}
