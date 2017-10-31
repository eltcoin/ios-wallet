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
    
    fileprivate func getEtherTransactionsURL() -> String{
        return baseAPI + "getAddressTransactions/\(WalletManager.sharedInstance.getWalletUnEncrypted()?.address ?? "")?showZeroValues=0&apiKey=\(apiKey)"
    }
    
    fileprivate func getTokenTransactionsURL(tokenAddress: String) -> String{
        return baseAPI + "getAddressHistory/\(WalletManager.sharedInstance.getWalletUnEncrypted()?.address ?? "")?token=\(tokenAddress)&apiKey=\(apiKey)"
    }
}

extension WalletTransactionsManager {
    
    func getEtherTransactions(transactionsImportCompleted: (([WalletTransaction])->Void)?){
        self.transactionsImportCompleted = transactionsImportCompleted
        
        let urlStr = getEtherTransactionsURL()
        print(urlStr)
        Alamofire.request(urlStr).responseArray { (response: DataResponse<[WalletTransaction]>) in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Ether Transactions Data: \(utf8Text)") // original server data as UTF8 string
            }
            
            if let result = response.result.value {
                self.transactionsImportCompleted!(result)
            } else if let error = response.result.error {
                // Handle error
                print("Ether Transactions Error")
                print(error)
            } else {
                // Handle some other not networking error
                print("Ether Transactions  - some other not networking error")
            }
        }
    }
    
    func getTokenTransactions(token: ETHTokenInfo, transactionsImportCompleted: (([WalletTransaction])->Void)?){
        self.transactionsImportCompleted = transactionsImportCompleted
        
        let urlStr = getTokenTransactionsURL(tokenAddress: token.address)
        print(urlStr)
        Alamofire.request(urlStr).responseObject { (response: DataResponse<WalletTransactionsReponse>) in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Token Transactions Data: \(utf8Text)") // original server data as UTF8 string
            }
            
            if let result = response.result.value {
                if let transactions = result.operations {
                    self.transactionsImportCompleted!(transactions)
                }else{
                    print("Token Transactions parse Error")
                }
            } else if let error = response.result.error {
                // Handle error
                print("Token Transactions Error")
                print(error)
            } else {
                // Handle some other not networking error
                print("Token Transactions  - some other not networking error")
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

