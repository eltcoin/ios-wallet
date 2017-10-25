//
//  ETHTokenInfo.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 24/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import ObjectMapper

class ETHTokenInfo : NetworkTaskResponse {
    
    var address = ""
    var name = ""
    var decimals: String = ""
    var symbol = ""
    var totalSupply = ""
    var owner = ""
    var lastUpdated = ""
    var issuancesCount = ""
    var holdersCount = ""
    var price = ""
    
    override func customInit(string: String) -> ETHTokenInfo? {
        return ETHTokenInfo(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            address <- map["address"]
            name <- map["name"]
            decimals <- map["decimals"]
            symbol <- map["symbol"]
            totalSupply <- map["totalSupply"]
            owner <- map["owner"]
            lastUpdated <- map["lastUpdated"]
            issuancesCount <- map["issuancesCount"]
            holdersCount <- map["holdersCount"]
            price <- map["price"]
        }else{
            address >>> map["address"]
            name >>> map["name"]
            decimals >>> map["decimals"]
            symbol >>> map["symbol"]
            totalSupply >>> map["totalSupply"]
            owner >>> map["owner"]
            lastUpdated >>> map["lastUpdated"]
            issuancesCount >>> map["issuancesCount"]
            holdersCount >>> map["holdersCount"]
            price >>> map["price"]
        }
    }
}

