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

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reachStatusChanged), name: "ReachStatusChanged", object: nil)
        reachStatusChanged()
    }


    func didLoadData(videos: [Videos]){
        self.videos = videos
        print(reachabilityStatus)

        tableView.reloadData()
    }
    
    func reachStatusChanged(){
        switch reachabilityStatus {
        case NOACCESS : //view.backgroundColor = UIColor.redColor()
        dispatch_async(dispatch_get_main_queue()){
          self.popUp()  
        }
        
        
        default:
            //view.backgroundColor = UIColor.greenColor()
            self.runAPI()
            

        }
    }
    
    func runAPI(){
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=50/json", completion: didLoadData)
    }
    
    func popUp(){
        let alert = UIAlertController(title: "No Internet access", message: "Turn it on", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {
            action -> () in
            print("Cancel")
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) {
            action -> () in
            print("delete")
        }
        let okAction = UIAlertAction(title: "ok", style: .Default) {
            action -> () in
            print("ok")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseIdentifier, forIndexPath: indexPath) as? MusicVideoTableViewCell
        
         cell?.video = videos[indexPath.row]
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 132
    }
    
    private struct storyboard {
        static let cellReuseIdentifier = "cell"
    }

}


