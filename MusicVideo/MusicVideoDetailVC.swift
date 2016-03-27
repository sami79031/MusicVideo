//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by Smail Ali on 3/27/16.
//  Copyright © 2016 Smail Ali. All rights reserved.
//

import UIKit

class MusicVideoDetailVC: UIViewController {
    
    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!
    var videos: Videos!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    func updateUI(){
        title = videos.vArtist
        vName.text = videos?.vName
        vPrice.text = videos?.vPrice
        vRights.text = videos?.vRights
        vGenre.text = videos?.vGenre
        
        if videos?.vImageData != nil{
            videoImage.image = UIImage(data: (videos?.vImageData)!)
        }else{
            videoImage.image = UIImage(named: "imageNotAvailable")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
