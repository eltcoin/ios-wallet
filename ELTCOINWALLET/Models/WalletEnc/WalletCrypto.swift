//
//  Crypto.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 16/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import ObjectMapper

class WalletCrypto : NetworkTaskResponse {
    
    var cipher = ""
    var cipherparams = WalletCipherParams()
    var ciphertext = ""
    var kdf = "scrypt"
    var kdfparams = WalletKDFParams()
    var mac = ""
    
    override func customInit(string: String) -> NetworkTaskResponse? {
        return WalletEncrypted(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            cipher    <- map["cipher"]
            cipherparams         <- map["cipherparams"]
            ciphertext      <- map["ciphertext"]
            kdf      <- map["kdf"]
            kdfparams      <- map["kdfparams"]
            mac      <- map["mac"]
        }else{
            cipher >>> map["cipher"]
            cipherparams >>> map["cipherparams"]
            ciphertext >>> map["ciphertext"]
            kdf >>> map["kdf"]
            kdfparams >>> map["kdfparams"]
            mac >>> map["mac"]
        }
    }
    
}
