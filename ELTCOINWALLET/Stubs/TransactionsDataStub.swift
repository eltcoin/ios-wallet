//
//  TransactionsDataStub.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 12/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation

class TransactionsDataStub {
    
    static func transactions() -> [WalletTransaction]{
        
        var walletTransactions = [WalletTransaction]();
        
        for _ in 0...100 {
            walletTransactions.append(generateTransaction())
        }
        
        return walletTransactions
    }
    
    static func generateTransaction() -> WalletTransaction{
        
        let sampleAddresses = [
            "0x93a408E47dBD8F1566316BFdE3BCC7DFe5FD8224",
            "0x77Ea29731140c0eDeb2D4871Ecdf7fbee0728Da0",
            "0x176807CD6C404d3f17a03827c9ABA483AfdF9178",
            "0xD5a6474F1e5931Fcbb9f86Be8661cD603729d0ab",
            "0x7f5feF05173D6687A648e11C092D3A19599970Ee",
            "0x3D6E39f9065048D4220c96cBd5F6C88B7fe5048e"]
        
        let type: WalletTransaction.TRANSACTION_TYPE = randomIntFrom(0, to: 1) == 1 ? .sent : .recieved
        
        var y = Double(round(100000000 * Double.random0to1())/100000000)
        
        y = (type == .recieved) ? y : y * (-1)
        
        let transaction = WalletTransaction()
        transaction.type = type
        transaction.value = "\(y)"
        transaction.from = sampleAddresses[randomIntFrom(0, to: 5)]
        
        return transaction
    }
    
    static func randomIntFrom(_ start: Int, to end: Int) -> Int {
        var a = start
        var b = end

        if a > b {
            swap(&a, &b)
        }
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
}
