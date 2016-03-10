//
//  ViewController.swift
//  Linkboard
//
//  Created by Agrim Asthana on 3/4/16.
//  Copyright (c) 2016 Agrim Asthana. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var topnews = [String]()
    var topnewsurls = [String]()
    var urls = [String]()
    @IBOutlet weak var tableView:UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource = self;
        let topnewsurl:String = "https://hacker-news.firebaseio.com/v0/topstories.json"
        let particulartopic:String = "https://hacker-news.firebaseio.com/v0/item/"
        Alamofire.request(.GET,topnewsurl)
            .responseJSON { response in
            let resJSON = JSON(response.result.value!)
                for  i in 0..<resJSON.count
                {
                    let res:String = particulartopic + resJSON[i].stringValue + ".json"
                    self.urls.append(res)
                }
                for x1 in 0..<self.urls.count
                {
                    Alamofire.request(.GET,self.urls[x1])
                        .responseJSON {response in
                            let topJSON = JSON(response.result.value!)
                            if let titles = topJSON["title"].stringValue as String?{
                                self.topnews.append(titles)
                            }
                            if let url = topJSON["url"].stringValue as String?{
                             self.topnewsurls.append(url)
                            }
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return self.topnews.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("splinterCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = self.topnews[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath index: NSIndexPath) {
        let ttlurl = self.topnewsurls[index.row]
        if ttlurl == "" {
            let alert = UIAlertController(title: "Warning", message: "No Url for story", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let webV:UIWebView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
            webV.loadRequest(NSURLRequest(URL: NSURL(string: ttlurl)!))
//            webV.delegate = self;
            self.view.addSubview(webV)
        }
    }

}

