//
//  ETYBalance.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 24/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import ObjectMapper

class ETHBalance : NetworkTaskResponse {
    
    var balance: Double = 0.0
    var totalIn: Double = 0.0
    var totalOut: Double = 0.0
    
    override func customInit(string: String) -> ETHBalance? {
        return ETHBalance(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            balance <- map["balance"]
            totalIn <- map["totalIn"]
            totalOut <- map["totalOut"]
        }else{
            balance >>> map["balance"]
            totalIn >>> map["totalIn"]
            totalOut >>> map["totalOut"]
        }
    }
}
