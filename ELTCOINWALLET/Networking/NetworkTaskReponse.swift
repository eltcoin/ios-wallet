//
//  NetworkTaskReponse.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 16/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import ObjectMapper

class NetworkTaskResponse : StaticMappable {
    
    required init?(map: Map) {
        
    }
    
    init(){
        
    }
    
    func customInit(string: String) -> NetworkTaskResponse? {
        return NetworkTaskResponse(JSONString: string)
    }
    
    public class func objectForMapping(map: Map) -> BaseMappable? {
        return self.init(map: map)
    }
    
    public func mapping(map: Map) {
        if map.mappingType == .fromJSON {
            
        }
    }
}

