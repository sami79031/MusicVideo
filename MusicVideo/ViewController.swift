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

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reachStatusChanged), name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.preferedFontChanged), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        reachStatusChanged()
        
        refreshControl.addTarget(self, action: #selector(ViewController.refreshView(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }


    func didLoadData(_ videos: [Videos]){
        self.videos = videos
        print(reachabilityStatus)

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
        title = ("The iTunes Top \(limit) Music Videos")
        
        resultSearchController.searchResultsUpdater = self
        definesPresentationContext = true
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search for Artist"
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        
        tableView.tableHeaderView = resultSearchController.searchBar
        
        tableView.reloadData()
    }
    
    func reachStatusChanged(){
        switch reachabilityStatus {
        case NOACCESS : //view.backgroundColor = UIColor.redColor()
        DispatchQueue.main.async{
          self.popUp()  
        }
        
        
        default:
            //view.backgroundColor = UIColor.greenColor()
            self.runAPI()
            

        }
    }
    
    func refreshView(_ refreshControl: UIRefreshControl) {
        if resultSearchController.isActive{
            refreshControl.attributedTitle = NSAttributedString(string: "No refresh allowed in search")
            refreshControl.endRefreshing()
        }else{
            let formatter = DateFormatter()
            formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
            let refreshDte = formatter.string(from: Date())
            refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
            refreshControl.attributedTitle = NSAttributedString(string:"\(refreshDte)")
            runAPI()
            
            refreshControl.endRefreshing()
        }
        
        
    }
    
    func getAPICount(){
        if let theValue = UserDefaults.standard.object(forKey: "APICNT"){
            limit = theValue as! Int
        }
    }
    
    
    func runAPI(){
        getAPICount()
        
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
    }
    
    func popUp(){
        let alert = UIAlertController(title: "No Internet access", message: "Turn it on", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            action -> () in
            print("Cancel")
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            action -> () in
            print("delete")
        }
        let okAction = UIAlertAction(title: "ok", style: .default) {
            action -> () in
            print("ok")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    func preferedFontChanged(){
        print("The prefered font has changed")
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive{
            return filterSearch.count
        }
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.cellReuseIdentifier, for: indexPath) as? MusicVideoTableViewCell
        
        if resultSearchController.isActive{
           cell?.video = filterSearch[(indexPath as NSIndexPath).row]
        }else{
           cell?.video = videos[(indexPath as NSIndexPath).row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    fileprivate struct storyboard {
        static let cellReuseIdentifier = "cell"
        static let segueIdentifier = "musicDetail"
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == storyboard.segueIdentifier{
            if let indexPath = tableView.indexPathForSelectedRow{
                let video: Videos
                if resultSearchController.isActive{
                    video = filterSearch[(indexPath as NSIndexPath).row]
                }else{
                    video = videos[(indexPath as NSIndexPath).row]
                }
                
                let dvc = segue.destination as! MusicVideoDetailVC
                dvc.videos = video
            }
        }
     }
    

    
    
    func filterSearch(_ searchText: String){
        filterSearch = videos.filter { videos in
            return videos.vName!.lowercased().contains(searchText.lowercased()) || videos.vArtist!.lowercased().contains(searchText.lowercased()) || "\(videos.vRank)".lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        _ = searchController.searchBar.text!.lowercased()
        filterSearch(searchController.searchBar.text!)
    }
}






