//
//  WalletTransactionsReponse.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 23/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import ObjectMapper

class WalletTransactionsReponse : NetworkTaskResponse {

    var result: [WalletTransaction]?
    var operations: [WalletTransaction]?

    override func customInit(string: String) -> WalletTransactionsReponse? {
        return WalletTransactionsReponse(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            result <- map["result"]
            operations <- map["operations"]
        }else{
            result >>> map["result"]
            operations >>> map["operations"]
        }
    }
}
