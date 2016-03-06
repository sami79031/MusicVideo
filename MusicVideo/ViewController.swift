//
//  ViewController.swift
//  MusicVideo
//
//  Created by Smail Ali on 2/28/16.
//  Copyright © 2016 Smail Ali. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var displayLable: UILabel!
    var videos = [Videos]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=50/json", completion: didLoadData)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachStatusChanged", name: "ReachStatusChanged", object: nil)
        reachStatusChanged()
    }


    func didLoadData(videos: [Videos]){
        self.videos = videos
        print(reachabilityStatus)
        
        for (index, item) in videos.enumerate(){
            print("\(index + 1) \(item.vName)")
        }
        
        tableView.reloadData()
    }
    
    func reachStatusChanged(){
        switch reachabilityStatus {
        case NOACCESS : view.backgroundColor = UIColor.redColor()
        displayLable.text = "No Internet"
        case WIFI : view.backgroundColor = UIColor.greenColor()
        displayLable.text = "Reachable with WIFI"
        case WWAN : view.backgroundColor = UIColor.yellowColor()
        displayLable.text = "Reachable with Cellular"
        default:return
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let video = videos[indexPath.row]
        
        cell.textLabel?.text = ("\(indexPath.row + 1)")
        
        cell.detailTextLabel?.text = video.vName
        
        return cell
        
    }

}

