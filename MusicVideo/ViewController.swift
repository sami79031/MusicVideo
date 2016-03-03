//
//  ViewController.swift
//  MusicVideo
//
//  Created by Smail Ali on 2/28/16.
//  Copyright © 2016 Smail Ali. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var videos = [Videos]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)
    }


    func didLoadData(videos: [Videos]){
        
        print(reachabilityStatus)
        
        for (index, item) in videos.enumerate(){
            print("\(index + 1) \(item.vName)")
        }
    }

}

