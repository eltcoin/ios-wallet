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

import Alamofire
import AlamofireObjectMapper

class NotificationManager {
 
    func registerDeviceWithServer(){
        
        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken"){
            
                print("registering fcmToken for a device")
                print(fcmToken)
                // call network:
                
                let device = PushDevice()
                device.FCMToken = fcmToken
            
                if UserDefaults.standard.object(forKey: "deviceUUID") == nil {
                    device.deviceUUID = UUID().uuidString
                    print("Generated a new deviceID '\(device.deviceUUID)' with the fcmToken: \(fcmToken)")
                    UserDefaults.standard.set(device.deviceUUID, forKey: "deviceUUID");
                    UserDefaults.standard.synchronize()
                }else{
                    let deviceUUID = UserDefaults.standard.string(forKey: "deviceUUID") ?? ""
                    device.deviceUUID = deviceUUID
                    print("This device '\(device.deviceUUID)' already has a fcmToken: \(fcmToken)")
                }

                if let wallet = WalletManager.sharedInstance.getWalletUnEncrypted(){
                    device.walletAddress = wallet.address
                }
                
                let parameters: Parameters = ["device": device.toJSON()]
                let url = NetworkWalletAPI.deviceURL()

                Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<PushDevice>) in
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("PushDevice Response Data: \(utf8Text)") // original server data as UTF8 string
                    }
                    
                    if let remotePushDevice = response.result.value {
                        if remotePushDevice.deviceUUID.count > 0 {
                            print("got my mydeviceUUID: \(remotePushDevice.deviceUUID)")
                        }else{
                            print("PushDevice Registrastion parse Error")
                        }
                    } else if let error = response.result.error {
                        print("PushDevice Registrastion Error")
                        print(error)
                    } else {
                        print("PushDevice Registrastion  - some other not networking error")
                    }
                }
            
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
