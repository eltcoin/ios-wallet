//
//  Walletkdfparams.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 16/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import ObjectMapper

class WalletKDFParams: NetworkTaskResponse {
    var dklen = 32
    var n = 1024
    var p = 1
    var r = 8
    var salt = ""
    
    override func customInit(string: String) -> NetworkTaskResponse? {
        return WalletCipherParams(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            dklen    <- map["dklen"]
            n    <- map["n"]
            p    <- map["p"]
            r    <- map["r"]
            salt    <- map["salt"]
        }else{
            dklen >>> map["dklen"]
            n >>> map["n"]
            p >>> map["p"]
            r >>> map["r"]
            salt >>> map["salt"]
        }
    }
}
