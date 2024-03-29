//
//  DetailViewController.swift
//  Leverage
//
//  Created by Todd Resudek on 6/17/15.
//  Copyright (c) 2015 supersimple. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backToList: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var scroll_view: UIScrollView!
    
    @IBOutlet weak var job_title: UILabel!
    @IBOutlet weak var job_desc: UILabel!
    
    let urlPath: String = "https://api.lever.co/v0/postings/"
    let responseMode = "json"
    var selected_job_guid: String = "";
    var request_path: String = ""
    var lever_url: String = ""
    var lever_api_key: String = ""
    var description_url: String = ""; //passed in via segue
    
    var job_text: NSString = "";
    var job_description: NSString = "";
    var job_lists: NSArray = [];
    var job_details = NSMutableAttributedString(string:"");
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backToList.layer.cornerRadius = 3
        backToList.contentEdgeInsets = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)
        applyButton.layer.cornerRadius = 3
        applyButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)
        
        self.loadPage();
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
    
    private func loadPage() {
        let url = NSURL(string: description_url)
        let session = NSURLSession.sharedSession()
        println(url);
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            
            
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSDictionary = jsonResult as NSDictionary
            dispatch_async(dispatch_get_main_queue(), {
                self.job_text = results["text"] as! NSString
                self.job_description = results["description"] as! NSString
                self.job_lists = results["lists"] as! NSArray
                for item in self.job_lists {
                    self.job_details.appendAttributedString(NSMutableAttributedString(string: "\n\n"));
                    //self.job_details += (item["text"]) as String;
                    var attrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(20)]
                    var boldString = NSMutableAttributedString(string:(item["text"]) as! String, attributes:attrs)
                    self.job_details.appendAttributedString(NSMutableAttributedString(attributedString: boldString));
                    self.job_details.appendAttributedString(NSMutableAttributedString(string: "\n"));
                    let aString: String = (item["content"]) as! String;
                    let bString = aString.stringByReplacingOccurrencesOfString("<li>", withString: "\n• ", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    let newString = bString.stringByReplacingOccurrencesOfString("</li>", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    self.job_details.appendAttributedString(NSMutableAttributedString(string: newString));
                    
                }
                
                self.completeViewText();
            })
        })
        
        task.resume()
        
    }
    
    func parseLeverUrl(str: String) -> String {
        var arr = str.componentsSeparatedByString("/");
        return arr.last!
    }
    
    internal func completeViewText(){
        job_title.text = job_text as? String;
        job_desc.text = job_description as String;
        (job_desc.attributedText as! NSMutableAttributedString).appendAttributedString(NSMutableAttributedString(attributedString: job_details));
        
        job_desc.font = UIFont(name: "Lato Hairline", size: 18.0)
        job_desc.numberOfLines = 0;
        job_desc.sizeToFit();
        scroll_view.contentSize = job_desc.frame.size
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showJobForm") {
            // pass data to next view
            //https://api.lever.co/v0/postings/masteryconnect/5721843f-8dd3-41e8-bfec-045c7c522cad
            let formViewController = segue.destinationViewController as! FormViewController
            formViewController.selected_job_guid = self.selected_job_guid;
            
            
            
            formViewController.description_url = self.urlPath + parseLeverUrl(self.lever_url) as String + "/" + self.selected_job_guid
        }
    }
    
}

