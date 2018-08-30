//
//  NotificationViewController.swift
//  NotificationController
//
//  Created by Yudiz Solutions on 03/08/18.
//  Copyright © 2018 Yudiz Solutions. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import AVKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var viewPlayer:UIView!
    
    let avPlayerController = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        //5. Set the proportional vertical size
        let size = view.bounds.size
        preferredContentSize = CGSize(width: size.width, height: size.height / 4)
    }
    
    //Called when notification arrive in your app
    func didReceive(_ notification: UNNotification) {
        videoPlay(true)
    }
    
    //Implement a method that will be called when user tapped on any notification action
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        if response.actionIdentifier == "select1" {
            videoPlay(false)
        }else if response.actionIdentifier == "select2" {
            videoPlay(true)
        }
        completion(.doNotDismiss)
    }
}

//MARK:- Actions
extension NotificationViewController {
    @IBAction func btnPlayTapped(_ sender: UIButton) {
        avPlayerController.player?.play()
    }
    
    @IBAction func btnPauseTapped(_ sender: UIButton) {
        avPlayerController.player?.pause()
    }
}


//MARK:- AVPlayer Delegate
extension NotificationViewController: AVPlayerViewControllerDelegate {
  
    func videoPlay(_ isOffline:Bool)
    {
        var avPlayer: AVPlayer!
        let filepath: String? = Bundle.main.path(forResource: "video1", ofType: "mp4")
        let fileURL = URL.init(fileURLWithPath: filepath!)
        let movieURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        if isOffline {
            avPlayer = AVPlayer(url: fileURL)
        }else{
            avPlayer = AVPlayer(url: movieURL!)
        }
        avPlayerController.player = avPlayer
        avPlayerController.view.frame = viewPlayer.frame
        avPlayerController.showsPlaybackControls = false
        avPlayerController.player?.play()
        self.view.addSubview(avPlayerController.view)
    }
}
