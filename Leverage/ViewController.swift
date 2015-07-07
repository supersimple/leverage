//
//  ViewController.swift
//  Leverage
//
//  Created by Todd Resudek on 6/17/15.
//  Copyright (c) 2015 supersimple. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var data = NSMutableData()

    
    var guid_value: String = "";
    var api_key_value: String = "";
    var items = [Job]()
    let urlPath: String = "https://api.lever.co/v0/postings/"
    let responseMode = "json"
    var selected_job_guid: String = "";
    var request_path: String = ""
    var lever_url: String = ""
    var lever_api_key: String = ""
    let userDefaults = NSUserDefaults.standardUserDefaults();
    
    
    @IBOutlet weak var jobsList: UITableView!
    @IBAction func showDetailView(sender: DetailButton) {
        self.selected_job_guid = sender.stored_guid as String
        //show the detail view
        self.performSegueWithIdentifier("showJobDetail", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    
        self.lever_url = parseLeverUrl(self.userDefaults.valueForKey("lever_url") as! String) as String
        self.lever_api_key = self.userDefaults.valueForKey("lever_api_key") as! String
        self.request_path = self.urlPath + self.lever_url + "?mode=" + self.responseMode;
        
        startConnection();
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkSettings() -> Bool{
        return false
    }
    
    func parseLeverUrl(str: String) -> String {
        var arr = str.componentsSeparatedByString("/");
        return arr.last!
    }
    
    func redirectToSettings(){
        //redirect to setting view conroller
        self.performSegueWithIdentifier("showSettings", sender: nil)
    }
    
    func startConnection(){
        
        var url: NSURL = NSURL(string: self.request_path)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    func buttonAction(sender: UIButton!){
        startConnection()
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        var jsonResult: NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSArray
        
        for item in jsonResult { // loop through data items
            let obj = item as! NSDictionary
            var job = Job(properties: obj)
            self.items.append(job)
            
        }
    
        //self.jobsList.registerClass(cellView.self, forCellReuseIdentifier: "cell")
        self.jobsList!.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:cellView = self.jobsList.dequeueReusableCellWithIdentifier("cell") as! cellView
        
        cell.cellJob.text = self.items[indexPath.row].text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as String
        cell.cellLocation.text = self.items[indexPath.row].categories["location"] as? String
        cell.cellButton.stored_guid = self.items[indexPath.row].uuid as! String
        //zebra table
        if(indexPath.row % 2 > 0){
            cell.backgroundColor = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1)
        }else{
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return cell
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

