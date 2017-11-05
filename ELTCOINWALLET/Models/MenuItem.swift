//
//  MenuItem.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 02/11/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit

class MenuItem: NSObject {
    
    var menuItemTitle = ""
    var menuItemImage: UIImage?
    var menuItemTag: Int = 0
    
    init(menuItemTitle: String, menuItemTag: Int) {
        super.init()
        self.menuItemTitle = menuItemTitle
        self.menuItemTag = menuItemTag
    }
}
