//
//  SettingsTVCTableViewController.swift
//  MusicVideo
//
//  Created by Smail Ali on 3/29/16.
//  Copyright © 2016 Smail Ali. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {
    
    @IBOutlet weak var aboutDisplay: UILabel!
    @IBOutlet weak var feedbackDisplay: UILabel!
    @IBOutlet weak var securityDisplay: UILabel!
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var bestImageDisplay: UILabel!
    @IBOutlet weak var APICount: UILabel!
    @IBOutlet weak var sliderCount: UISlider!
    let defaults = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.alwaysBounceVertical = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.preferedFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        title = "settings"
        touchID.on = NSUserDefaults.standardUserDefaults().boolForKey("SecSettings")
        
        if let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT"){
            APICount.text = "\(theValue)"
            sliderCount.value = Float(theValue as! Int)
        }
    }
    
    @IBAction func touchIdSec(sender: UISwitch) {
        defaults.setBool(touchID.on, forKey: "SecSettings")
    }
    
    @IBAction func valueChanged(sender: UISlider) {
        defaults.setObject(Int(sliderCount.value), forKey: "APICNT")
        APICount.text = ("\(Int(sliderCount.value))")
    }

    func preferedFontChanged(){
        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        feedbackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        bestImageDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        APICount.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
}
