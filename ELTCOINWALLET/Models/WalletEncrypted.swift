//
//  Wallet.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 16/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import ObjectMapper

class WalletEncrypted : NetworkTaskResponse {
    
    var Crypto = WalletCrypto()
    var address = ""
    var version = 3
    
    override func customInit(string: String) -> WalletEncrypted? {
        return WalletEncrypted(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            Crypto    <- map["Crypto"]
            address         <- map["address"]
            version      <- map["version"]
        }else{
            Crypto >>> map["Crypto"]
            address >>> map["address"]
            version >>> map["version"]
        }
    }
}
