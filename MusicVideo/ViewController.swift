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
    var limit = 10
    let refreshControl = UIRefreshControl()
    var filterSearch = [Videos]()
    let resultSearchController  = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reachStatusChanged), name: "ReachStatusChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.preferedFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        reachStatusChanged()
        
        refreshControl.addTarget(self, action: #selector(ViewController.refreshView(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }


    func didLoadData(videos: [Videos]){
        self.videos = videos
        print(reachabilityStatus)

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        title = ("The iTunes Top \(limit) Music Videos")
        
        resultSearchController.searchResultsUpdater = self
        definesPresentationContext = true
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search for Artist"
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        
        tableView.tableHeaderView = resultSearchController.searchBar
        
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
    
    func refreshView(refreshControl: UIRefreshControl) {
        if resultSearchController.active{
            refreshControl.attributedTitle = NSAttributedString(string: "No refresh allowed in search")
            refreshControl.endRefreshing()
        }else{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
            let refreshDte = formatter.stringFromDate(NSDate())
            refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
            refreshControl.attributedTitle = NSAttributedString(string:"\(refreshDte)")
            runAPI()
            
            refreshControl.endRefreshing()
        }
        
        
    }
    
    func getAPICount(){
        if let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT"){
            limit = theValue as! Int
        }
    }
    
    
    func runAPI(){
        getAPICount()
        
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
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
    
    
    func preferedFontChanged(){
        print("The prefered font has changed")
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.active{
            return filterSearch.count
        }
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseIdentifier, forIndexPath: indexPath) as? MusicVideoTableViewCell
        
        if resultSearchController.active{
           cell?.video = filterSearch[indexPath.row]
        }else{
           cell?.video = videos[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 132
    }
    
    private struct storyboard {
        static let cellReuseIdentifier = "cell"
        static let segueIdentifier = "musicDetail"
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == storyboard.segueIdentifier{
            if let indexPath = tableView.indexPathForSelectedRow{
                let video: Videos
                if resultSearchController.active{
                    video = filterSearch[indexPath.row]
                }else{
                    video = videos[indexPath.row]
                }
                
                let dvc = segue.destinationViewController as! MusicVideoDetailVC
                dvc.videos = video
            }
        }
     }
    

    
    
    func filterSearch(searchText: String){
        filterSearch = videos.filter { videos in
            return videos.vName!.lowercaseString.containsString(searchText.lowercaseString) || videos.vArtist!.lowercaseString.containsString(searchText.lowercaseString) || "\(videos.vRank)".lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.text!.lowercaseString
        filterSearch(searchController.searchBar.text!)
    }
}






