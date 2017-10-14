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

class NewWalletViewController: UIViewController {
    
    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    var topBarCloseButton = UIButton()
    
    // CTA Buttons
    let createWalletButton = UIButton()
    let importWalletButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.CustomColor.White.offwhite
        setupViews()
    }
    
    func setupViews(){
        
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
        topBarCloseButton.addTarget(self, action: #selector(SendCoinViewController.closeButtonPressed), for: .touchUpInside)
        topBarCloseButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.left.equalTo(topBarBackgroundView.snp.left).offset(10)
        }
        
        // CTA Buttons
        
        view.addSubview(createWalletButton)
        createWalletButton.setTitle("Create Wallet", for: .normal)
        createWalletButton.titleLabel?.textColor = UIColor.CustomColor.Black.DeepCharcoal
        createWalletButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        createWalletButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(topBarBackgroundLineView.snp.bottom).offset(50)
        }
        
        view.addSubview(importWalletButton)
        importWalletButton.setTitle("Import Wallet", for: .normal)
        importWalletButton.titleLabel?.textColor = UIColor.CustomColor.Black.DeepCharcoal
        importWalletButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        importWalletButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(createWalletButton.snp.bottom).offset(10)
        }
        
    }
    
    @objc func createButtonPressed(){
        let nv = UINavigationController(rootViewController: ScannerViewController())
        self.present( nv, animated: true, completion: nil)
    }
    
    @objc func importButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}
