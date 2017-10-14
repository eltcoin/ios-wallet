//
//  WalletTransaction.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 12/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation

class WalletTransaction {
    
    enum TRANSACTION_TYPE {
        case sent
        case recieved
    }
    
    var type: TRANSACTION_TYPE = TRANSACTION_TYPE.recieved
    var value: Double = 0.00
    var walletAddress: String = ""
    
    init(type: TRANSACTION_TYPE, value: Double, walletAddress: String) {
        self.type = type
        self.value = value
        self.walletAddress = walletAddress
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
