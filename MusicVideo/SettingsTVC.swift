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
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.alwaysBounceVertical = false
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.preferedFontChanged), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        title = "settings"
        touchID.isOn = UserDefaults.standard.bool(forKey: "SecSettings")
        
        if let theValue = UserDefaults.standard.object(forKey: "APICNT"){
            APICount.text = "\(theValue)"
            sliderCount.value = Float(theValue as! Int)
        }
    }
    
    @IBAction func touchIdSec(_ sender: UISwitch) {
        defaults.set(touchID.isOn, forKey: "SecSettings")
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        defaults.set(Int(sliderCount.value), forKey: "APICNT")
        APICount.text = ("\(Int(sliderCount.value))")
    }

    func preferedFontChanged(){
        aboutDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        feedbackDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        securityDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        bestImageDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        APICount.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1{
            let mailComposer = configureMail()
            
            if MFMailComposeViewController.canSendMail(){
                self.present(mailComposer, animated: true, completion: nil)
            }else{
                mailAlert()
            }
            tableView.deselectRow(at: indexPath, animated: true)
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
