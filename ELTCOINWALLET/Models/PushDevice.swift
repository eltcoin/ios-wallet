//
//  Device.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 09/11/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//


import Foundation
import ObjectMapper

class PushDevice : NetworkTaskResponse {
    
    var deviceUUID: String = ""
    var FCMToken: String = ""
    var walletAddress: String = ""

    override func customInit(string: String) -> PushDevice? {
        return PushDevice(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            deviceUUID <- map["deviceUUID"]
            FCMToken <- map["FCMToken"]
            walletAddress <- map["walletAddress"]
        }else{
            deviceUUID >>> map["deviceUUID"]
            FCMToken >>> map["FCMToken"]
            walletAddress >>> map["walletAddress"]
        }
    }
}
