//
//  ImportWalletViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 18/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ImportWalletViewController: UIViewController {
    
    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    var topBarCloseButton = UIButton()
    
    // Import Wallet Options - Buttons
    let selectKeystoreFileButton = UIButton()
    let inputPrivateKeyButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.view.backgroundColor = UIColor.white
        
        // TOP VIEWS
        self.view.addSubview(topBarBackgroundView)
        topBarBackgroundView.snp.makeConstraints { (make) in
            make.height.equalTo(64)
            make.top.centerX.width.equalTo(view)
        }
        
        topBarBackgroundView.addSubview(topBarTitleLabel)
        topBarTitleLabel.textAlignment = .center
        topBarTitleLabel.numberOfLines = 0
        topBarTitleLabel.textColor = UIColor.CustomColor.Black.DeepCharcoal
        topBarTitleLabel.text = "Import Wallet"
        topBarTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        topBarTitleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(topBarBackgroundView)
            make.top.equalTo(topBarBackgroundView.snp.top).offset(30)
            make.width.equalTo(topBarBackgroundView)
        }
        
        topBarBackgroundView.addSubview(topBarBackgroundLineView)
        topBarBackgroundLineView.backgroundColor = UIColor.CustomColor.Grey.lightGrey
        topBarBackgroundLineView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(view)
            make.top.equalTo(topBarBackgroundView.snp.bottom)
            make.height.equalTo(1)
        }
        
        topBarBackgroundView.addSubview(topBarCloseButton)
        topBarCloseButton.setBackgroundImage(UIImage(imageLiteralResourceName: "closeIcon"), for: UIControlState.normal);
        topBarCloseButton.addTarget(self, action: #selector(ImportWalletViewController.closeButtonPressed), for: .touchUpInside)
        topBarCloseButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.left.equalTo(topBarBackgroundView.snp.left).offset(10)
        }
        
        // Button Options
        
        view.addSubview(selectKeystoreFileButton)
        selectKeystoreFileButton.setTitle("Select Keystore File", for: .normal)
        selectKeystoreFileButton.backgroundColor = UIColor.CustomColor.Black.DeepCharcoal
        selectKeystoreFileButton.layer.cornerRadius = 4.0
        selectKeystoreFileButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        selectKeystoreFileButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(topBarBackgroundLineView.snp.bottom).offset(50)
        }
        selectKeystoreFileButton.addTarget(self, action: #selector(ImportWalletViewController.selectKeystoreButtonPressed), for: .touchUpInside)
        
        view.addSubview(inputPrivateKeyButton)
        inputPrivateKeyButton.setTitle("Input Private Key", for: .normal)
        inputPrivateKeyButton.backgroundColor = UIColor.CustomColor.Black.DeepCharcoal
        inputPrivateKeyButton.layer.cornerRadius = 4.0
        inputPrivateKeyButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        inputPrivateKeyButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(selectKeystoreFileButton.snp.bottom).offset(20)
        }
        selectKeystoreFileButton.addTarget(self, action: #selector(ImportWalletViewController.inputPrivateKeyButtonPressed), for: .touchUpInside)
        
    }
}

extension ImportWalletViewController {
    
    @objc func inputPrivateKeyButtonPressed(){
        
    }
    
    @objc func selectKeystoreButtonPressed(){
        
    }
    
    @objc func closeButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}
