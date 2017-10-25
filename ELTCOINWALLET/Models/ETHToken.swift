//
//  File.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 24/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import ObjectMapper

class ETHToken : NetworkTaskResponse {
    
    var tokenInfo: ETHTokenInfo?
    var balance: Double = 0.0
    var totalIn: Double = 0.0
    var totalOut: Double = 0.0
    
    override func customInit(string: String) -> ETHToken? {
        return ETHToken(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            tokenInfo <- map["tokenInfo"]
            balance <- map["balance"]
            totalIn <- map["totalIn"]
            totalOut <- map["totalOut"]
        }else{
            tokenInfo >>> map["tokenInfo"]
            balance >>> map["balance"]
            totalIn >>> map["totalIn"]
            totalOut >>> map["totalOut"]
        }
    }
    
    func getBalance() -> Double {
        let decimals = (Int((self.tokenInfo?.decimals)!))!
        let divisable = pow(10, decimals)
        return self.balance / NSDecimalNumber(decimal: divisable).doubleValue
    }
}
