//
//  ETHToken.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 24/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import ObjectMapper

class ETHTokenBalance : NetworkTaskResponse {
    
    var address = ""
    var ETH: ETHBalance?
    var countTxs = false
    var tokens: [ETHToken]?
    
    override func customInit(string: String) -> ETHTokenBalance? {
        return ETHTokenBalance(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            address <- map["address"]
            ETH <- map["ETH"]
            countTxs <- map["countTxs"]
            tokens <- map["tokens"]
        }else{
            address >>> map["address"]
            ETH >>> map["ETH"]
            countTxs >>> map["countTxs"]
            tokens >>> map["tokens"]
        }
    }
}

extension ETHTokenBalance {
    
    func getELTCOINBalance() -> Double {
        
        if let tokens = self.tokens {
            for token in tokens {
                if let info = token.tokenInfo {
                    if info.name == "ELTCOIN" {
                        return token.balance / 100000000.0
                    }
                }
            }
        }
        
        return 0.0
    }
}
