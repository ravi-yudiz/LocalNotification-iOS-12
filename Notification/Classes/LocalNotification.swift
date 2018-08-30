//
//  LocalNotification.swift
//  Notification
//
//  Created by Yudiz Solutions on 03/08/18.
//  Copyright © 2018 Yudiz Solutions. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotification: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
    }
}

//MARK:- Action
extension LocalNotification {
    
    @IBAction func btnNotificationTapped(_ sender: UIButton) {
        
        ///Local Notification Action Sheet
        let actionSheet = UIAlertController(title: "Select NotificationType", message: "", preferredStyle: .actionSheet)
        
        let simpleNotification = UIAlertAction(title: "Simple Notification", style: .default) { (type) in
            self.notification(title: "Simple Notification", subTitle: "Some Notification Example", badge: 1, body: "Some  Notification Example Display", threadIdentifire: "11", categoryIdentifire: "cat1", triggerTimeInterval: 2, triggerRepeat: false, reqIdentifire: "timer11", action: false, attachment: false)
        }
        let actionNotification = UIAlertAction(title: "Notification With Action", style: .default) { (type) in
            self.notification(title: "Notification With Action", subTitle: "Notification with Actions", badge: 1, body: "This is a actionable notification example", threadIdentifire: "12", categoryIdentifire: "cat2", triggerTimeInterval: 2, triggerRepeat: false, reqIdentifire: "timer12", action: true, attachment: false)
        }
        let richNotification = UIAlertAction(title: "Rich Notification", style: .default) { (type) in
            self.notification(title: "Rich Notification", subTitle: "Rich Notification Example", badge: 1, body: "This is a rich notification with action example", threadIdentifire: "13", categoryIdentifire: "category", triggerTimeInterval: 2, triggerRepeat: false, reqIdentifire: "timer13", action: true, attachment: true)
        }
        let groupNotification = UIAlertAction(title: "Group Notification", style: .default) { (type) in
            for i in 1...6 {
                self.notification(title: "Group Notification", subTitle: "Group Notification Example", badge: 1, body: "This is a group notification example", threadIdentifire: "groupThread", categoryIdentifire: "cat3", triggerTimeInterval: 2, triggerRepeat: false, reqIdentifire: "timer\(i)", action: false, attachment: false)
            }
        }
        
        actionSheet.addAction(simpleNotification)
        actionSheet.addAction(actionNotification)
        actionSheet.addAction(richNotification)
        actionSheet.addAction(groupNotification)

        present(actionSheet,animated: true)
    }
    
    
    /// Removing simpleNotification

    @IBAction func btnRemoveNotificationTapped(_ sender: UIButton) {
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            let isLocal = notifications.contains(where: { (notification) -> Bool in
                return notification.request.identifier == "timer11"
            })
            if isLocal {
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:  ["timer11"])
            }else{
                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (notificationRequests) in
                    let isLocal = notificationRequests.contains(where: { (request) -> Bool in
                        return request.identifier == "timer11"
                    })
                    if isLocal {
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["timer11"])
                    }
                })
            }
        }
    }
}

//MARK:- UserNotification Delegate
extension LocalNotification: UNUserNotificationCenterDelegate {

    // Notification is shows on foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    //Notification action handler
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "select1" {
            print("First Screen Tapped")
        }else if response.actionIdentifier == "select2"{
            print("Second Screen Tapped")
        }
    }
}

//MARK:- Functions
extension LocalNotification {
        
    func notification(title:String, subTitle:String, badge: NSNumber, body: String, threadIdentifire:String, categoryIdentifire:String, triggerTimeInterval:TimeInterval, triggerRepeat:Bool, reqIdentifire:String , action:Bool,attachment:Bool){
        
        //get the notification center
        let content = UNMutableNotificationContent()

        //create the content for the notification
        content.title = title
        content.subtitle = subTitle
        content.badge = badge
        content.body = body
        content.sound = UNNotificationSound.default
        
        //define thread identifire for group Notification
        content.threadIdentifier = threadIdentifire
        
        //define category identifire for action perform
        content.categoryIdentifier = categoryIdentifire
        
        if attachment {
            let url = Bundle.main.url(forResource: "img2", withExtension: "png")
            let attachment = try! UNNotificationAttachment(identifier: "image", url: url!, options: [:])
            content.attachments = [attachment]
        }

        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerTimeInterval, repeats: triggerRepeat)
        
        //create request to display
        let request = UNNotificationRequest(identifier: reqIdentifire, content: content, trigger: trigger)
    
        //add request to notification center
        UNUserNotificationCenter.current().add(request) { (err) in
            print(err)
        }
        
        if action {
            // Define the custom actions.
            let action1 = UNNotificationAction(identifier: "select1", title: "First Screen", options: [.foreground])
            let action2 = UNNotificationAction(identifier: "select2", title: "Second Screen", options: [.foreground])
            
            // Create category with unique identifier
            let category = UNNotificationCategory(identifier: categoryIdentifire, actions: [action1,action2], intentIdentifiers: [], options: [])
            
            // Register the category with the notification center.
            UNUserNotificationCenter.current().setNotificationCategories([category])
        }
    }
}
