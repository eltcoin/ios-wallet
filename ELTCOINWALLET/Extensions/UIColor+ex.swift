//
//  Color+ex.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 12/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    struct CustomColor {
        struct Black {
            static let DeepCharcoal = UIColor(netHex: 0x202124)
        }
        struct Grey {
            static let lightGrey = UIColor(netHex: 0xF2F2F2)
            static let midGrey = UIColor(netHex: 0xA6A6A7)
            static let disabled = UIColor(netHex: 0xE5E5E5)
        }
        struct White {
            static let offwhite = UIColor(netHex: 0xFAFAFA)
        }
        struct Yellow {
            static let niceYellow = UIColor(netHex: 0xFFD600)
        }
        struct Red {
            static let notificationRed = UIColor(netHex: 0xFF2B2B)
        }
        struct Green {
            static let positiveGreen = UIColor(netHex: 0x34BE40)
        }
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

