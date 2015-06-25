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
    var urlPath: String = "https://api.lever.co/v0/postings/masteryconnect?mode=json"
    
    
    @IBOutlet weak var jobsList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = NSUserDefaults.standardUserDefaults();
        
        let lever_url:String = userDefaults.valueForKey("lever_url") as! String
        let lever_api_key:String = userDefaults.valueForKey("lever_api_key") as! String
        
        startConnection();
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    func startConnection(){
        
        var url: NSURL = NSURL(string: self.urlPath)!
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
        //zebra table
        if(indexPath.row % 2 > 0){
            cell.backgroundColor = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1)
        }else{
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showJobDetail") {
            // pass data to next view
            println()
        }
    }
    
}

