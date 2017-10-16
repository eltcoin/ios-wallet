//
//  JSAPIResponse.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 16/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import ObjectMapper

class WalletUnEncryptedJSAPIResponse : NetworkTaskResponse {
    var tag = ""
    var payload = WalletUnEncrypted()
    
    override func customInit(string: String) -> WalletUnEncryptedJSAPIResponse? {
        return WalletUnEncryptedJSAPIResponse(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            tag         <- map["tag"]
            payload      <- map["payload"]
        }else{
            tag >>> map["tag"]
            payload >>> map["payload"]
        }
    }
}
