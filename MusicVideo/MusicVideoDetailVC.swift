//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by Smail Ali on 3/27/16.
//  Copyright © 2016 Smail Ali. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import LocalAuthentication

class MusicVideoDetailVC: UIViewController {
    var securitySwitch = false
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
            videoImage.image = UIImage(data: (videos?.vImageData)! as Data)
        }else{
            videoImage.image = UIImage(named: "imageNotAvailable")
        }
    }

    
    @IBAction func playVideo(_ sender: UIBarButtonItem) {
        let url = URL(string: videos.vVideoUrl!)
        let player = AVPlayer(url: url!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true){
            playerViewController.player?.play()
        }
        
    }
    
    @IBAction func socialMedia(_ sender: UIBarButtonItem) {
        securitySwitch = UserDefaults.standard.bool(forKey: "SecSettings")
        
        switch securitySwitch {
        case true:
            touchIDCheck()
            print("in the touchid")
        default:
            print("in the sharedMedia")
            shareMedia()
        }
    }
    
    func touchIDCheck(){
        // Create an alert
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "continue", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        // Create the Local Authentication Context
        let context = LAContext()
        var touchIDError : NSError?
        let reasonString = "Touch-Id authentication is needed to share info on Social Media"
        
        
        // Check if we can access local device authentication
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error:&touchIDError) {
            // Check what the authentication response was
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in
                if success {
                    // User authenticated using Local Device Authentication Successfully!
                    DispatchQueue.main.async { [unowned self] in
                        self.shareMedia()
                    }
                } else {
                    
                    alert.title = "Unsuccessful!"
                    
                    switch LAError.Code(rawValue: policyError!._code)! {
                        
                    case .appCancel:
                        alert.message = "Authentication was cancelled by application"
                        
                    case .authenticationFailed:
                        alert.message = "The user failed to provide valid credentials"
                        
                    case .passcodeNotSet:
                        alert.message = "Passcode is not set on the device"
                        
                    case .systemCancel:
                        alert.message = "Authentication was cancelled by the system"
                        
                    case .touchIDLockout:
                        alert.message = "Too many failed attempts."
                        
                    case .userCancel:
                        alert.message = "You cancelled the request"
                        
                    case .userFallback:
                        alert.message = "Password not accepted, must use Touch-ID"
                        
                    default:
                        alert.message = "Unable to Authenticate!"
                        
                    }
                    
                    // Show the alert
                    DispatchQueue.main.async { [unowned self] in
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        } else {
            // Unable to access local device authentication
            
            // Set the error title
            alert.title = "Error"
            
            // Set the error alert message with more information
            switch LAError.Code(rawValue: touchIDError!.code)! {
                
            case .touchIDNotEnrolled:
                alert.message = "Touch ID is not enrolled"
                
            case .touchIDNotAvailable:
                alert.message = "TouchID is not available on the device"
                
            case .passcodeNotSet:
                alert.message = "Passcode has not been set"
                
            case .invalidContext:
                alert.message = "The context is invalid"
                
            default:
                alert.message = "Local Authentication not available"
            }
            
            // Show the alert
            DispatchQueue.main.async { [unowned self] in
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func shareMedia(){
        let act1 = "Have you checked the Music Video?"
        let act2 = ("\(videos.vName) by \(videos.vArtist)")
        let act3 = "Watch it"
        let act4 = videos.vLinkToiTunes
        let act5 = "(Shared with the Music Video App - Step it UP!)"
        
        let activityVC = UIActivityViewController(activityItems: [act1, act2, act3, act4!, act5], applicationActivities: nil)
        
        //if you want to exclude apps for sharing
        //activityVC.excludedActivityTypes = [UIActivityTypeMail, UIActivityTypeMessage]
        
        activityVC.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if activity == UIActivityType.mail {
                print("email selected")
            }
        }
        
        self.present(activityVC, animated: true, completion: nil)
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
