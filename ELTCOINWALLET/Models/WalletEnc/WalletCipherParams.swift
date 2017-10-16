//
//  WalletCipherParams.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 16/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import ObjectMapper

class WalletCipherParams : NetworkTaskResponse {
    var iv = ""
    
    override func customInit(string: String) -> NetworkTaskResponse? {
        return WalletCipherParams(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            iv    <- map["iv"]
        }else{
            iv >>> map["iv"]
        }
    }
}
