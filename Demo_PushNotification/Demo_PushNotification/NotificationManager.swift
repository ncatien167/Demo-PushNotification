//
//  NotificationManager.swift
//  Demo_PushNotification
//
//  Created by Apple on 1/5/18.
//  Copyright © 2018 ncatien167@gmail.com. All rights reserved.
//

import UIKit
import UIKit
import UserNotifications

class NotificationManager: NSObject {

    static let shared: NotificationManager = {
        return NotificationManager()
    }()
    
    var isAuthorized = false
    
    func requestAuthorization() {
        //Authorization
        let options:UNAuthorizationOptions = [.badge, .alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted: Bool, error: Error?) in
            if granted{
                print("Notification Authorized")
                self.isAuthorized = true
            }else{
                self.isAuthorized = false
                print("Notification Not Authorized")
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func schdule(date: Date, repeats: Bool) -> Date? {
        cancelAllNotifcations()
        
        //Attache an image to our notification as we saw in the intro
        guard let filePath = Bundle.main.path(forResource: "LocationPin", ofType: "png") else {
            print("Image not found")
            return nil
        }
        let attachement = try! UNNotificationAttachment(identifier: "attachement", url: URL.init(fileURLWithPath: filePath), options: nil)
        
        //Content Notification
        let content = UNMutableNotificationContent()
        content.title = "Hello, Anh Tien"
        content.body = date.formattedDate
        content.userInfo = ["testInfo":"hello"]
        //content.sound = UNNotificationSound.default() //Defaul in device
        content.sound = UNNotificationSound.init(named: "Avicii_-_The_Nights_Lyrics_HD_.aiff") //Custom sound with your file
        content.attachments = [attachement]

        //In order to init the trigger we need a dateComponent
        let components = Calendar.current.dateComponents([.minute,.hour], from: date)
        var newComponent = DateComponents()
        newComponent.hour = components.hour
        newComponent.minute = components.minute
        newComponent.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponent, repeats: repeats)
        
        //Create request
        let request = UNNotificationRequest(identifier: "TestNotificationId", content: content, trigger: trigger)
        
        //Add request
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            if error == nil {
                print("Notification Schduled",trigger.nextTriggerDate()?.formattedDate ?? "Date nil")
            }else {
                print("Error schduling a notification",error?.localizedDescription ?? "")
            }
        }
        
        return trigger.nextTriggerDate()
    }
    
    //Handle get all list of notification request
    func getAllPendingNotifications(completion: @escaping ([UNNotificationRequest]?) -> Void){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            return completion(requests)
        }
    }
    
    //Handle cancel all notification
    func cancelAllNotifcations() {
        getAllPendingNotifications { (requests: [UNNotificationRequest]?) in
            if let requestsIds = requests{
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: requestsIds.map{$0.identifier})
            }
        }
    }
    
}

    //MARK: - UNUserNotificationCenterDelegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Local Notifcation Received while app is open",notification.request.content)
        completionHandler(UNNotificationPresentationOptions.sound)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Did tap on the notification",response.notification.request.content)
        completionHandler()
    }
    
}






