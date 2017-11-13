//
//  ImportWalletFileViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 27/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView

class ImportWalletFileViewController: UIViewController {
    
    let loadingView = UIView()

    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    
    // Form Items
    let passwordTextView = SkyFloatingLabelTextField()
    
    // Import Wallet Options - Buttons
    let doneButton = UIButton()
    let cancelButton = UIButton()
    
    // Imported File:
    var jsonString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.view.backgroundColor = UIColor.white
        
        view.addSubview(loadingView)
        loadingView.isHidden = true
        
        // TOP VIEWS
        let topOffset = UIDevice.current.iPhoneX ? 20 : 0
        
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
        topBarTitleLabel.text = "Enter KeyStore Password"
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
        
        view.addSubview(passwordTextView)
        passwordTextView.placeholder = "Enter Password"
        passwordTextView.title = "KeyStore Password"
        passwordTextView.text = ""
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
            make.top.equalTo(passwordTextView.snp.bottom).offset(50)
        }
        doneButton.addTarget(self, action: #selector(ImportWalletFileViewController.doneButtonPressed), for: .touchUpInside)
        
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
        cancelButton.addTarget(self, action: #selector(ImportWalletFileViewController.cancelButtonPressed), for: .touchUpInside)
        
    }
}

extension ImportWalletFileViewController {
    
    @objc func doneButtonPressed(){
        if let password = self.passwordTextView.text {
            
            toggleLoadingState(true)
            WalletImportFileManager(password: password, fileContent: jsonString, walletImportCompleted: { (walletUnEncrypted) in
                WalletManager.sharedInstance.setWalletUnEncrypted(wallet: walletUnEncrypted)
                self.toggleLoadingState(false)
                self.navigationController?.dismiss(animated: true, completion: nil)
            }, errBlock: { (errorMessage) in
                self.toggleLoadingState(false)
                let errorPopup = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                errorPopup.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(errorPopup, animated: true, completion: nil)
            })
                .startImport()
        }
    }
    
    @objc func cancelButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func toggleLoadingState(_ isLoading: Bool) {
        
        loadingView.isHidden = true
        doneButton.isHidden = false
        if(isLoading){
            doneButton.isHidden = true
            loadingView.isHidden = false
            loadingView.backgroundColor = UIColor.CustomColor.White.offwhite
            loadingView.snp.makeConstraints({ (make) in
                make.center.height.width.equalTo(self.view)
            })
            
            let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            let loadingIndicator = NVActivityIndicatorView(frame: frame, type: .ballBeat, color: UIColor.CustomColor.Black.DeepCharcoal, padding: 1)
            
            loadingView.addSubview(loadingIndicator)
            loadingIndicator.snp.makeConstraints({ (make) in
                make.center.equalTo(doneButton)
            })
            loadingIndicator.startAnimating()
        }
    }
}
