//
//  SettingsTVCTableViewController.swift
//  MusicVideo
//
//  Created by Smail Ali on 3/29/16.
//  Copyright © 2016 Smail Ali. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1{
            let mailComposer = configureMail()
            
            if MFMailComposeViewController.canSendMail(){
                self.presentViewController(mailComposer, animated: true, completion: nil)
            }else{
                mailAlert()
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func configureMail()-> MFMailComposeViewController{
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["sami79031@gmail.com"])
        
        return mailComposer
    }
    
    func mailAlert(){
         print("NO email!!!")
    }
    
    
}
