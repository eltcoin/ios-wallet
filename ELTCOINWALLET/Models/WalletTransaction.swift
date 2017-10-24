//
//  WalletTransaction.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 12/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import ObjectMapper

class WalletTransaction: NetworkTaskResponse {
    
    enum TRANSACTION_TYPE {
        case sent
        case recieved
    }

    var timeStamp: String = ""
    var from: String = ""
    var to: String = ""
    var hash: String = ""
    var value: String = ""
    var success: Bool = false
    
    var type: TRANSACTION_TYPE {
        get {
            if (to == WalletManager.sharedInstance.getWalletEncrypted()?.address && to.characters.count > 0) {
                return TRANSACTION_TYPE.recieved
            }else{
                return TRANSACTION_TYPE.sent
            }
        }
        set {}
    }
    
    
    override func customInit(string: String) -> WalletTransaction? {
        return WalletTransaction(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            timeStamp         <-  map["timeStamp"]
            hash         <-  map["hash"]
            from         <-  map["from"]
            to         <-  map["to"]
            value         <-  map["value"]
            success         <-  map["success"]
        }else{
            timeStamp         >>>  map["timeStamp"]
            hash         >>>  map["hash"]
            from        >>>  map["from"]
            to        >>>  map["to"]
            value         >>> map["value"]
            success        >>>  map["success"]
        }
    }
}

extension WalletTransaction {
    
    func description() -> String {
        switch self.type {
            case .sent:
                return "Sent"
            case .recieved:
                return "Recieved"
        }
    }
}
