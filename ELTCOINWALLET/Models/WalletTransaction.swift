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

    var blockNumber: String = ""
    var timeStamp: String = ""
    var hash: String = ""
    var nonce: String = ""
    var blockHash: String = ""
    var transactionIndex: String = ""
    var from: String = ""
    var to: String = ""
    var value: String = ""
    var gas: String = ""
    var gasPrice: String = ""
    var isError: String = ""
    var input: String = ""
    var contractAddress: String = ""
    var cumulativeGasUsed: String = ""
    var gasUsed: String = ""
    var confirmations: String = ""
    
    var type: TRANSACTION_TYPE = TRANSACTION_TYPE.recieved
    //var value: Int64 = 0
    //var walletAddress: String = ""

    
    override func customInit(string: String) -> WalletTransaction? {
        return WalletTransaction(JSONString: string)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            blockNumber         <-  map["blockNumber"]
            timeStamp         <-  map["timeStamp"]
            hash         <-  map["hash"]
            nonce         <-  map["nonce"]
            blockHash         <-  map["blockHash"]
            transactionIndex         <-  map["transactionIndex"]
            from         <-  map["from"]
            to         <-  map["to"]
            value         <-  map["value"]
            gas         <-  map["gas"]
            gasPrice         <-  map["gasPrice"]
            isError         <-  map["isError"]
            contractAddress         <-  map["contractAddress"]
            cumulativeGasUsed         <-  map["cumulativeGasUsed"]
            gasUsed         <-  map["gasUsed"]
            confirmations         <-  map["confirmations"]
        }else{
            blockNumber >>> map["blockNumber"]
            timeStamp         >>>  map["timeStamp"]
            hash         >>>  map["hash"]
            nonce         >>>  map["nonce"]
            blockHash         >>>  map["blockHash"]
            transactionIndex        >>>  map["transactionIndex"]
            from        >>>  map["from"]
            to        >>>  map["to"]
            value         >>> map["value"]
            gas        >>>  map["gas"]
            gasPrice        >>>  map["gasPrice"]
            isError        >>>  map["isError"]
            contractAddress        >>>  map["contractAddress"]
            cumulativeGasUsed        >>>  map["cumulativeGasUsed"]
            gasUsed       >>>  map["gasUsed"]
            confirmations       >>>  map["confirmations"]
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
