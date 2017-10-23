//
//  ImportWalletPK.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 23/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//


import Foundation
import UIKit
import SnapKit
import SkyFloatingLabelTextField

class ImportWalletPKViewController: UIViewController {
    
    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    var topBarCloseButton = UIButton()
    
    // Form Items
    let privateKeyTextView = SkyFloatingLabelTextField()
    
    // Import Wallet Options - Buttons
    let doneButton = UIButton()
    let cancelButton = UIButton()
    
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
        topBarCloseButton.addTarget(self, action: #selector(ImportWalletPKViewController.closeButtonPressed), for: .touchUpInside)
        topBarCloseButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.left.equalTo(topBarBackgroundView.snp.left).offset(10)
        }
        
        view.addSubview(privateKeyTextView)
        privateKeyTextView.placeholder = "Enter Private Key"
        privateKeyTextView.title = "Private Key"
        privateKeyTextView.text = ""
        privateKeyTextView.setTitleVisible(true)
        privateKeyTextView.returnKeyType = .go
        privateKeyTextView.tintColor = UIColor.CustomColor.Black.DeepCharcoal
        privateKeyTextView.selectedTitleColor = UIColor.CustomColor.Grey.midGrey
        privateKeyTextView.selectedLineColor = UIColor.CustomColor.Grey.midGrey
        privateKeyTextView.autocapitalizationType = .none
        privateKeyTextView.keyboardType = UIKeyboardType.default
        privateKeyTextView.isSecureTextEntry = true
        privateKeyTextView.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        privateKeyTextView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.centerX.equalTo(view)
            make.top.equalTo(topBarBackgroundView.snp.bottom).offset(20)
        }
        
        // Button Options
        
        view.addSubview(doneButton)
        doneButton.setTitle("Import", for: .normal)
        doneButton.backgroundColor = UIColor.CustomColor.Black.DeepCharcoal
        doneButton.layer.cornerRadius = 4.0
        doneButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        doneButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(privateKeyTextView.snp.bottom).offset(50)
        }
        doneButton.addTarget(self, action: #selector(ImportWalletPKViewController.doneButtonPressed), for: .touchUpInside)
        
        view.addSubview(cancelButton)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.backgroundColor = UIColor.white
        cancelButton.layer.cornerRadius = 4.0
        cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        cancelButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(doneButton.snp.bottom).offset(20)
        }
        cancelButton.addTarget(self, action: #selector(ImportWalletPKViewController.closeButtonPressed), for: .touchUpInside)
        
    }
}

extension ImportWalletPKViewController {
    
    @objc func doneButtonPressed(){
        if let privateKay = self.privateKeyTextView.text {
            WalletImportManager.init(privateKey: privateKay, walletImportCompleted: { (wallet) in
                print("imported wallet with a Private key")
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @objc func closeButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}
