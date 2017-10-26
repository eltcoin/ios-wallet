//
//  WalletTransactionManager.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 17/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class WalletTransactionsManager {
    var baseAPI = "https://api.ethplorer.io/"
    var apiKey = "freekey"
    
    public var transactionsImportCompleted: (([WalletTransaction])->Void)?
    public var balanceImportCompleted: ((ETHTokenBalance)->Void)?
}

extension WalletTransactionsManager {
    fileprivate func getBalanceURL() -> String{
        return baseAPI + "getAddressInfo/\(WalletManager.sharedInstance.getWalletUnEncrypted()?.address ?? "")?apiKey=\(apiKey)"
    }
    
    fileprivate func getTransactionsURL() -> String{
        return baseAPI + "getAddressTransactions/\(WalletManager.sharedInstance.getWalletUnEncrypted()?.address ?? "")?showZeroValues=1&apiKey=\(apiKey)"
    }
}

extension WalletTransactionsManager {
    
    func getTransactions(transactionsImportCompleted: (([WalletTransaction])->Void)?){
        self.transactionsImportCompleted = transactionsImportCompleted
        
        let urlStr = getTransactionsURL()
        print(urlStr)
        Alamofire.request(urlStr).responseArray { (response: DataResponse<[WalletTransaction]>) in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
            if let result = response.result.value {
                self.transactionsImportCompleted!(result)
            } else if let error = response.result.error {
                // Handle error
                print("error")
                print(error)
            } else {
                // Handle some other not networking error
                print("some other not networking error")
            }
        }
        
    }
    
    func getBalance(balanceImportCompleted: ((ETHTokenBalance)->Void)?){
        self.balanceImportCompleted = balanceImportCompleted
        let urlStr = getBalanceURL()
        print(urlStr)
        
        Alamofire.request(urlStr).responseJSON { response in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                
                if let balanceResult = ETHTokenBalance().customInit(string: utf8Text) {
                    print("balanceResult: \(balanceResult)") // serialized json response
                   
                    self.balanceImportCompleted!(balanceResult)
                }
            }
        }
    }
}

