//
//  SendCoinViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 12/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SkyFloatingLabelTextField

class SendCoinViewController: UIViewController {
    
    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    var topBarCloseButton = UIButton()

    // Form Elements
    let coinVolumeTextField = SkyFloatingLabelTextField()
    let desitnationWalletAddressTextField = SkyFloatingLabelTextField()
    var sendButton = UIButton()
    
    var scanQRCodeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.CustomColor.White.offwhite
        
        sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width , height: 60)) // Keyboard accessory button
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
        topBarTitleLabel.text = "Send"
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
        
        // Form Elements
        
        view.addSubview(coinVolumeTextField)
        coinVolumeTextField.placeholder = "0.00000000"
        coinVolumeTextField.title = "ELT Volume"
        coinVolumeTextField.returnKeyType = .next
        coinVolumeTextField.tintColor = UIColor.CustomColor.Black.DeepCharcoal
        coinVolumeTextField.selectedTitleColor = UIColor.CustomColor.Grey.midGrey
        coinVolumeTextField.selectedLineColor = UIColor.CustomColor.Grey.midGrey
        coinVolumeTextField.autocapitalizationType = .none
        coinVolumeTextField.keyboardType = UIKeyboardType.decimalPad
        coinVolumeTextField.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        coinVolumeTextField.keyboardAppearance = .dark
        coinVolumeTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.leftMargin).offset(30)
            make.right.equalTo(view.snp.rightMargin).offset(-30)
            make.centerX.equalTo(view)
            make.top.equalTo(topBarBackgroundLineView.snp.bottom).offset(50)
        }
        
        view.addSubview(desitnationWalletAddressTextField)
        desitnationWalletAddressTextField.placeholder = "0x93a408E47dBD8F1566316BFdE3BCC7DFe5FD8224"
        desitnationWalletAddressTextField.title = "Wallet Addres"
        desitnationWalletAddressTextField.returnKeyType = .next
        coinVolumeTextField.tintColor = UIColor.CustomColor.Black.DeepCharcoal
        desitnationWalletAddressTextField.selectedTitleColor = UIColor.CustomColor.Grey.midGrey
        desitnationWalletAddressTextField.selectedLineColor = UIColor.CustomColor.Grey.midGrey
        desitnationWalletAddressTextField.autocapitalizationType = .none
        desitnationWalletAddressTextField.keyboardAppearance = .dark
        desitnationWalletAddressTextField.keyboardType = UIKeyboardType.default
        desitnationWalletAddressTextField.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        desitnationWalletAddressTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.leftMargin).offset(30)
            make.right.equalTo(view.snp.rightMargin).offset(-30-60)
            make.centerX.equalTo(view)
            make.top.equalTo(coinVolumeTextField).offset(50)
        }
        
        view.addSubview(scanQRCodeButton)
        scanQRCodeButton.addTarget(self, action: #selector(SendCoinViewController.scanButtonPressed), for: .touchUpInside)
        scanQRCodeButton.setBackgroundImage(UIImage(imageLiteralResourceName: "qrCodeIcon"), for: UIControlState.normal);
        scanQRCodeButton.snp.makeConstraints { (make) in
            make.top.equalTo(coinVolumeTextField).offset(50)
            make.right.equalTo(view.snp.rightMargin).offset(-30)
            make.width.height.equalTo(50)
        }
        
        //view.addSubview(sendButton)
        sendButton.backgroundColor = UIColor.black
        sendButton.setTitle("SEND", for: .normal)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        
        coinVolumeTextField.inputAccessoryView = sendButton
        desitnationWalletAddressTextField.inputAccessoryView = sendButton
        
        coinVolumeTextField.becomeFirstResponder()
    }
    
    @objc func scanButtonPressed(){
        let nv = UINavigationController(rootViewController: ScannerViewController())
        self.present( nv, animated: true, completion: nil)
    }
    
    @objc func closeButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}
