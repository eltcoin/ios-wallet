//
//  WalletTransactionManager.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 17/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import Alamofire

class WalletTransactionsManager {
    var baseAPI = "https://api.etherscan.io/api?"
    var apiKey = ""
    
    public var transactionsImportCompleted: (([WalletTransaction])->Void)?
    public var balanceImportCompleted: ((Int64)->Void)?
}

extension WalletTransactionsManager {
    fileprivate func getBalanceURL() -> String{
        return baseAPI + "module=account&action=balance&address=\(WalletManager.sharedInstance.getWalletUnEncrypted()?.address ?? "")&tag=latest&apikey=\(apiKey)"
    }
    
    fileprivate func getTransactionsURL() -> String{
        return baseAPI + "module=account&action=txlist&address=\(WalletManager.sharedInstance.getWalletUnEncrypted()?.address ?? "")&startblock=0&endblock=99999999&sort=asc&apikey=\(apiKey)"
    }
}

extension WalletTransactionsManager {
    
    func getTransactions(transactionsImportCompleted: (([WalletTransaction])->Void)?){
        self.transactionsImportCompleted = transactionsImportCompleted
        
        let urlStr = getTransactionsURL()
        Alamofire.request(urlStr).responseJSON { response in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                
                if let transactionResult = WalletTransactionsReponse().customInit(string: utf8Text) {
                    print("transResult: \(transactionResult)") // serialized json response
                    self.transactionsImportCompleted!(transactionResult.result!)
                }
            }
        }
    }
    
    
    func getBalance(balanceImportCompleted: ((Int64)->Void)?){
        self.balanceImportCompleted = balanceImportCompleted
        let urlStr = getBalanceURL()
        Alamofire.request(urlStr).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                print("JSON: \(json)") // serialized json response
                if let myBalanceStr = json["result"] as? String {
                    if let myBalance = Int64(myBalanceStr) {
                        self.balanceImportCompleted!(myBalance)
                    }
                }
            }
        }
    }
}

