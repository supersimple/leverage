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
    let defaultApiKey = "5ac21346-8e0c-4494-8e7a-3eb92ff77902"
    let defaultUrl = "leverdemo";
    let userDefaults = NSUserDefaults.standardUserDefaults();
    var list_location: Bool = true
    var list_team: Bool = true
    var list_commitment: Bool = true
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var settingsWarning: UIView!
    @IBOutlet weak var settingsWarningLabel: UILabel!
    @IBOutlet weak var jobsList: UITableView!
    @IBAction func showDetailView(sender: DetailButton) {
        self.selected_job_guid = sender.stored_guid as String
        //show the detail view
        self.performSegueWithIdentifier("showJobDetail", sender: nil)
    }
    @IBOutlet weak var goToSettingsButton: UIButton!
    @IBAction func goToSettingsButton(sender: AnyObject) {
        redirectToSettings()
    }
    @IBOutlet weak var goToSettings: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.startAnimating();
        // Do any additional setup after loading the view, typically from a nib
        self.lever_url = parseLeverUrl(self.userDefaults.valueForKey("lever_url") as! String) as String
        self.lever_api_key = settingOrDefault(self.userDefaults.valueForKey("lever_api_key") as! String, def: defaultApiKey) as String
        self.request_path = self.urlPath + self.lever_url + "?mode=" + self.responseMode;
        self.list_location = (self.userDefaults.valueForKey("list_location") as? Bool)!
        self.list_team = (self.userDefaults.valueForKey("list_team") as? Bool)!
        self.list_commitment = (self.userDefaults.valueForKey("list_commitment") as? Bool)!
        
        startConnection();
        
        if(self.lever_url == defaultUrl || self.lever_api_key == defaultApiKey){
//            settingsWarning.layer.cornerRadius = 3
//            settingsWarning.layer.borderColor = UIColor( red: 66/255, green: 66/255, blue:66/255, alpha: 0.9 ).CGColor
//            settingsWarning.layer.borderWidth = 1.0
            if(self.lever_url == defaultUrl){
                settingsWarningLabel.text = "You are currently viewing sample data. Please go to your settings to customize the app for your account."
            }else if(self.lever_api_key == defaultApiKey){
                settingsWarningLabel.text = "You currently do not have an API Key set. Please go to your settings to customize the app for your account."
            }
            goToSettingsButton.layer.cornerRadius = 3
            goToSettingsButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)
            settingsWarning.hidden = false
        }else{
            //hide the modal warning
            settingsWarning.hidden = true
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        activity.stopAnimating();
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
        // Need to add meta from settings
        // list_location, list_team, list_commitment
        cell.cellLocation.text = prepareStringForConcat(checkForNil(self.items[indexPath.row].categories, k: "location") as String!, display: self.list_location) +
            prepareStringForConcat(checkForNil(self.items[indexPath.row].categories,k: "team") as String!, display: self.list_team) +
            prepareStringForConcat(checkForNil(self.items[indexPath.row].categories,k: "commitment") as String!, display: self.list_commitment)
        
        
        cell.cellButton.stored_guid = self.items[indexPath.row].uuid as! String
        //zebra table
        if(indexPath.row % 2 > 0){
            cell.backgroundColor = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1)
        }else{
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return cell
    }
    
    private func checkForNil(dict: NSDictionary, k: String) -> String{
        if let tmp: AnyObject = dict[k]{
            
            if let val = dict[k] as? String {
                return val;
            }else{
                return ""
            }
            
        }else{
            return ""
        }
    }
    
    private func settingOrDefault(str: AnyObject, def: String) -> String{
        if((str as AnyObject!) == nil){
            return def
        }else if((str as! String).isEmpty){
            return def
        }else{
            return str as! String
        }
    }
    
    private func prepareStringForConcat(str: String, display: Bool) -> String{
        if(display){
            if((str as AnyObject!) == nil){
                return ""
            }else if((str as String).isEmpty){
                return ""
            }else{
                return (str as String) + "   "
            }
        }
        return ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showJobDetail") {
            // pass data to next view
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.selected_job_guid = self.selected_job_guid;
            detailViewController.description_url = self.urlPath + self.lever_url + "/" + self.selected_job_guid
        }
    }
    
}

