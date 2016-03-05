//
//  ViewController.swift
//  MusicVideo
//
//  Created by Smail Ali on 2/28/16.
//  Copyright © 2016 Smail Ali. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLable: UILabel!
    var videos = [Videos]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachStatusChanged", name: "ReachStatusChanged", object: nil)
        reachStatusChanged()
    }


    func didLoadData(videos: [Videos]){
        
        print(reachabilityStatus)
        
        for (index, item) in videos.enumerate(){
            print("\(index + 1) \(item.vName)")
        }
    }
    
    func reachStatusChanged(){
        displayLable.text = reachabilityStatus
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }

}

