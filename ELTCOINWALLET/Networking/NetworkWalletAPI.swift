//
//  NetworkAPI.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 09/11/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation

struct NetworkWalletAPI {
    static let URL = "https://cryptowallet-api.herokuapp.com/api/1"
    //static let URL = "https://cryptowallet-api-staging.herokuapp.com/api/1"
    //static let URL = "http://localhost:8082/api/1"
    
    static func deviceURL() -> String {
        return URL + "/device"
    }
}
