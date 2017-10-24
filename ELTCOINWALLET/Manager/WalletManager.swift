//
//  WalletManager.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 16/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation

class WalletManager {
    static let sharedInstance = WalletManager()
    private init() {}
    
    enum WALLET_EVENTS : String {
        case NEW_WALLET_ERR = "NEW_WALLET_ERR",
        NEW_WALLET = "NEW_WALLET",
        NEW_WALLET_ENC = "NEW_WALLET_ENC",
        IMPORTED_WALLET_PK = "IMPORTED_WALLET_PK",
        IMPORTED_WALLET_FILE = "IMPORTED_WALLET_FILE"
    }
}

extension WalletManager {
    
    func setWalletUnEncrypted(wallet: WalletUnEncrypted!) {
        let JSONString = wallet.toJSONString(prettyPrint: true)
        UserDefaults.standard.setValue(JSONString, forKey: "wallet")
        UserDefaults.standard.synchronize()
    }
    
    func getWalletUnEncrypted() -> WalletUnEncrypted?{
        
        UserDefaults.standard.synchronize()
        let JSONString = UserDefaults.standard.string(forKey: "wallet")
        
        if JSONString != nil {
            let wallet = WalletUnEncrypted(JSONString: JSONString!)
            return wallet;
        }else {
            return nil
        }
    }
    
}

extension WalletManager {
    
    func setWalletEncrypted(wallet: WalletEncrypted!) {
        let JSONString = wallet.toJSONString(prettyPrint: true)
        UserDefaults.standard.setValue(JSONString, forKey: "wallet_enc")
        UserDefaults.standard.synchronize()
    }
    
    func getWalletEncrypted() -> WalletEncrypted?{
        
        UserDefaults.standard.synchronize()
        let JSONString = UserDefaults.standard.string(forKey: "wallet_enc")
        
        if JSONString != nil {
            let wallet = WalletEncrypted(JSONString: JSONString!)
            return wallet;
        }else {
            return nil
        }
    }
    
}

