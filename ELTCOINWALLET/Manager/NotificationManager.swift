//
//  NotificationManager.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 30/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import UIKit
import NotificationCenter
import UserNotifications

class NotificationManager {
 
    fileprivate func registerDeviceWithServer(){
        
        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken"){
            // TODO: networking task
        }
    }
    
    func registerForPushNotifications(){
        
        let application = UIApplication.shared
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        registerDeviceWithServer()
    }
}
