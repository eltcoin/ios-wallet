//
//  WalletUnEncrypted.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 16/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import ObjectMapper

class WalletUnEncrypted : NetworkTaskResponse {
    
    var address = ""
    var checksumAddress = ""
    var encrypted = false
    var privKey = ""
    var pubKey = ""
    var publisher = ""
    var version = 2
    
    override func customInit(string: String) -> WalletUnEncrypted? {
        return WalletUnEncrypted(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            address         <- map["address"]
            checksumAddress      <- map["checksumAddress"]
            encrypted      <- map["encrypted"]
            privKey      <- map["privKey"]
            pubKey      <- map["pubKey"]
            publisher      <- map["publisher"]
            version      <- map["version"]
        }else{
            address >>> map["address"]
            checksumAddress >>> map["checksumAddress"]
            encrypted >>> map["encrypted"]
            privKey >>> map["privKey"]
            pubKey >>> map["pubKey"]
            publisher >>> map["publisher"]
            version >>> map["version"]
        }
    }
}

extension WalletUnEncrypted {
    func getCurrentBalanceUSD() -> Double {
        return 367.89
    }
    func getCurrentBalanceELTCOIN() -> Double {
        return 367.89260350
    }
}
