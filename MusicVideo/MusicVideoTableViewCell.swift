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
        musicTitle.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        rank.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
        musicTitle.text = video!.vName
        rank.text = ("\(video!.vRank)")
        //musicImage.image = UIImage(named: "imageNotAvailable")
        
        if video!.vImageData != nil {
            print("Get data from array")
            musicImage.image = UIImage(data: video!.vImageData! as Data)
        }else {
            GetViedeoImage(video!, imageView: musicImage)
            print("Get data from API")
        }
    }
    
    func GetViedeoImage(_ video: Videos, imageView: UIImageView){
        
        DispatchQueue.main.async {
            let data = try? Data(contentsOf: URL(string: video.vImageUrl!)!)
            
            var image: UIImage?
            if data != nil {
                video.vImageData = data
                image = UIImage(data: data!)
            } else{
                self.musicImage.image = UIImage(named: "imageNotAvailable")
            }
            
            //move back to main queue
            DispatchQueue.main.async{
                imageView.image = image
            }
        }
    }

}
