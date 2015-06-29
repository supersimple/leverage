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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backToDetailButton.layer.cornerRadius = 3
        backToDetailButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showJobDetail") {
            // pass data to next view
            //https://api.lever.co/v0/postings/masteryconnect/5721843f-8dd3-41e8-bfec-045c7c522cad
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.description_url = self.urlPath + self.lever_url + "/" + self.selected_job_guid
        }
    }
    
}
