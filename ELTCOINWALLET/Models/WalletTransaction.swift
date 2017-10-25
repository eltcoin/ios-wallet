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

    var timestamp: Int64 = 0
    var from: String = ""
    var to: String = ""
    var hash: String = ""
    var input: String = ""
    var value: Double = 0.0
    var success: Bool = false
    
    var type: TRANSACTION_TYPE {
        get {
            if (to == WalletManager.sharedInstance.getWalletUnEncrypted()?.address && to.characters.count > 0) {
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
            timestamp         <-  map["timestamp"]
            hash         <-  map["hash"]
            from         <-  map["from"]
            to         <-  map["to"]
            value         <-  map["value"]
            success         <-  map["success"]
        }else{
            timestamp         >>>  map["timestamp"]
            hash         >>>  map["hash"]
            from        >>>  map["from"]
            to        >>>  map["to"]
            value         >>> map["value"]
            success        >>>  map["success"]
        }
    }
}

extension WalletTransaction {
    
    func transactionDate() -> String {
        let date = Date(timeIntervalSince1970: Double(self.timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMM d, HH:mm a" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func description() -> String {
        switch self.type {
            case .sent:
                return "Sent"
            case .recieved:
                return "Recieved"
        }
    }
}
