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
    var transactionHash: String = ""
    var from: String = ""
    var to: String = ""
    var hash: String = ""
    var input: String = ""
    var value: String = ""
    var valueDouble: Double = 0.0
    var success: Bool = false
    var tokenInfo: ETHTokenInfo?
    
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
            timestamp <- map["timestamp"]
            transactionHash <- map["transactionHash"]
            hash <- map["hash"]
            from <- map["from"]
            to <- map["to"]
            input <- map["input"]
            valueDouble <- map["value"]
            value <- map["value"]
            success <- map["success"]
            tokenInfo <- map["tokenInfo"]
            
            if value.characters.count == 0 {
                value = String(valueDouble)
            }
        }else{
            timestamp >>> map["timestamp"]
            transactionHash >>> map["transactionHash"]
            hash >>> map["hash"]
            from >>> map["from"]
            to >>> map["to"]
            input >>> map["input"]
            value >>> map["value"]
            success >>> map["success"]
            tokenInfo >>> map["tokenInfo"]
        }
    }
}

extension WalletTransaction {
    
    func transactionValue() -> Double{
        let rawValue = Double(self.value) ?? 0.0
        let decValue = self.tokenInfo?.decimals ?? 0.0
        
        if decValue == 0 {
            return rawValue
        }else{
            let powValue = pow(10, decValue)
            let transactionValue = rawValue / powValue
            return transactionValue;
        }
    }
    
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
