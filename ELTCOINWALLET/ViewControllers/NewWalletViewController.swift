//
//  NewWalletViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 14/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView

class NewWalletViewController: UIViewController {
    
    let loadingView = UIView()
    
    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    var topBarCloseButton = UIButton()
    
    // Form Items
    let passwordTextView = SkyFloatingLabelTextField()
    let orLabel = UILabel()
    let createWalletButton = UIButton()
    let importWalletButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.CustomColor.White.offwhite
        setupViews()
        checkIfWalletSetup()
    }
    
    func checkIfWalletSetup(){
        if let wallet = WalletManager.sharedInstance.getWalletUnEncrypted(){
            if wallet.address.count == 0 {
                topBarCloseButton.isHidden = true
            }
        }else{
            topBarCloseButton.isHidden = true
        }
    }
    
    func setupViews(){
        
        view.addSubview(loadingView)
        loadingView.isHidden = true
        
        // TOP VIEWS
        
        let  topOffset = UIDevice.current.iPhoneX ? 20 : 0
        
        self.view.addSubview(topBarBackgroundView)
        topBarBackgroundView.snp.makeConstraints { (make) in
            make.height.equalTo(64)
            make.top.equalTo(view).offset(topOffset)
            make.centerX.width.equalTo(view)
        }
        
        topBarBackgroundView.addSubview(topBarTitleLabel)
        topBarTitleLabel.textAlignment = .center
        topBarTitleLabel.numberOfLines = 0
        topBarTitleLabel.textColor = UIColor.CustomColor.Black.DeepCharcoal
        topBarTitleLabel.text = "New Wallet"
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
        topBarCloseButton.addTarget(self, action: #selector(SendTokensViewController.closeButtonPressed), for: .touchUpInside)
        topBarCloseButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.left.equalTo(topBarBackgroundView.snp.left).offset(10)
        }
        
        // Form inputs
        
        view.addSubview(passwordTextView)
        passwordTextView.placeholder = "Password"
        passwordTextView.title = "Secure New Wallet With Password"
        //passwordTextView.delegate = self
        passwordTextView.setTitleVisible(true)
        passwordTextView.returnKeyType = .go
        passwordTextView.tintColor = UIColor.CustomColor.Black.DeepCharcoal
        passwordTextView.selectedTitleColor = UIColor.CustomColor.Grey.midGrey
        passwordTextView.selectedLineColor = UIColor.CustomColor.Grey.midGrey
        passwordTextView.autocapitalizationType = .none
        passwordTextView.keyboardType = UIKeyboardType.default
        passwordTextView.isSecureTextEntry = true
        passwordTextView.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        passwordTextView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.centerX.equalTo(view)
            make.top.equalTo(topBarBackgroundView.snp.bottom).offset(20)
        }
        
        view.addSubview(createWalletButton)
        createWalletButton.setTitle("Create Wallet", for: .normal)
        createWalletButton.setTitle("Loading...", for: .disabled)

        createWalletButton.backgroundColor = UIColor.CustomColor.Black.DeepCharcoal
        createWalletButton.layer.cornerRadius = 4.0
        createWalletButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        createWalletButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(passwordTextView.snp.bottom).offset(20)
        }
        createWalletButton.addTarget(self, action: #selector(NewWalletViewController.createWalletButtonPressed), for: .touchUpInside)
        
        view.addSubview(orLabel)
        orLabel.text = "-or-"
        orLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        orLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(createWalletButton.snp.bottom).offset(10)
        }
        
        view.addSubview(importWalletButton)
        importWalletButton.setTitle("Import Wallet", for: .normal)
        importWalletButton.setTitleColor(UIColor.CustomColor.Black.DeepCharcoal, for: .normal)
        importWalletButton.layer.cornerRadius = 4.0
        importWalletButton.titleLabel?.textColor = UIColor.CustomColor.Black.DeepCharcoal
        importWalletButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        importWalletButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(orLabel.snp.bottom).offset(10)
        }
        importWalletButton.addTarget(self, action: #selector(NewWalletViewController.importWalletButtonPressed), for: .touchUpInside)

    }

}

//MARK: Actions
extension NewWalletViewController {
    
    @objc func createWalletButtonPressed(){
        if let password = passwordTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            
            createWalletButton.isEnabled = false
            self.toggleLoadingState(true)
            self.view.endEditing(true)
            
            WalletCreationManager(password: password, walletCreationCompleted: { (walletEncrypted, walletUnEncrypted) in
                WalletManager.sharedInstance.setWalletUnEncrypted(wallet: walletUnEncrypted)
                WalletManager.sharedInstance.setWalletEncrypted(wallet: walletEncrypted)
                self.toggleLoadingState(false)
                self.createWalletButton.isEnabled = true
                self.navigationController?.pushViewController(WalletCreatedViewController(), animated: true)
            }, errBlock: { (errorMessage) in
                self.toggleLoadingState(false)
                let errorPopup = UIAlertController(title: "Oops", message: errorMessage, preferredStyle: .alert)
                errorPopup.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(errorPopup, animated: true, completion: nil)
                self.createWalletButton.isEnabled = true
            })
            .createWallet()
        }
    }
    
    @objc func importWalletButtonPressed(){
        self.navigationController?.pushViewController(ImportWalletViewController(), animated: true)
    }
    
    @objc func closeButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func toggleLoadingState(_ isLoading: Bool) {
        
        loadingView.isHidden = true
        
        if(isLoading){
            loadingView.isHidden = false
            loadingView.backgroundColor = UIColor.CustomColor.White.offwhite
            loadingView.snp.makeConstraints({ (make) in
                make.center.height.width.equalTo(self.view)
            })
            
            let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            let loadingIndicator = NVActivityIndicatorView(frame: frame, type: .ballBeat, color: UIColor.CustomColor.Black.DeepCharcoal, padding: 1)
            
            loadingView.addSubview(loadingIndicator)
            loadingIndicator.snp.makeConstraints({ (make) in
                make.height.width.equalTo(50)
                make.center.equalTo(loadingView)
            })
            loadingIndicator.startAnimating()
        }
    }
}
