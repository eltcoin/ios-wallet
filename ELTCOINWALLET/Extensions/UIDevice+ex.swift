//
//  UIDevice+ex.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 03/11/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
}
