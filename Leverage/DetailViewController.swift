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
    
    @IBOutlet weak var job_title: UILabel!
    @IBOutlet weak var job_desc: UILabel!
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadPage() {
        let url = NSURL(string: description_url)
        let session = NSURLSession.sharedSession()
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
    
    internal func completeViewText(){
        job_title.text = job_text as? String;
        job_desc.text = job_description as String;
        (job_desc.attributedText as! NSMutableAttributedString).appendAttributedString(NSMutableAttributedString(attributedString: job_details));
        
    }
    
    
}

