//
//  PopupNavigationController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 12/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import Material

class PopupNavigationController: UINavigationController {
    
    //MARK: Private Properties
    fileprivate let animator = Animator()
    
    //MARK: Internal Properties
    var transitionType : TransitionType = .pushFromBottom
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

