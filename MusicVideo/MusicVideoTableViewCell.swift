//
//  MusicVideoTableViewCell.swift
//  MusicVideo
//
//  Created by Smail Ali on 3/21/16.
//  Copyright © 2016 Smail Ali. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {

    var video: Videos? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var musicTitle: UILabel!
    
    func updateCell(){
        musicTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        rank.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        musicTitle.text = video!.vName
        rank.text = ("\(video!.vRank)")
        //musicImage.image = UIImage(named: "imageNotAvailable")
        
        if video!.vImageData != nil {
            print("Get data from array")
            musicImage.image = UIImage(data: video!.vImageData!)
        }else {
            GetViedeoImage(video!, imageView: musicImage)
            print("Get data from API")
        }
    }
    
    func GetViedeoImage(video: Videos, imageView: UIImageView){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            let data = NSData(contentsOfURL: NSURL(string: video.vImageUrl!)!)
            
            var image: UIImage?
            if data != nil {
                video.vImageData = data
                image = UIImage(data: data!)
            } else{
                self.musicImage.image = UIImage(named: "imageNotAvailable")
            }
            
            //move back to main queue
            dispatch_async(dispatch_get_main_queue()){
                imageView.image = image
            }
        }
    }

}
