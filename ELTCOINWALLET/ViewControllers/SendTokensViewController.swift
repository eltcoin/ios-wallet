//
//  SendTokensViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 12/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SkyFloatingLabelTextField

class SendTokensViewController: UIViewController {
    
    var currentToken: ETHToken?
    
    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    var topBarCloseButton = UIButton()
    var topBarCurrencyButton = UIButton()

    // Form Elements
    let coinVolumeTextField = SkyFloatingLabelTextField()
    let gasLimitTextField = SkyFloatingLabelTextField()
    let destinationWalletAddressTextField = SkyFloatingLabelTextField()
    
    var currentBalanceLabel = UILabel()
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
        topBarTitleLabel.text = "Send Tokens"
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
        
        topBarBackgroundView.addSubview(topBarCurrencyButton)
        topBarCurrencyButton.contentHorizontalAlignment = .right
        topBarCurrencyButton.setTitleColor(UIColor.black, for: .normal)
        topBarCurrencyButton.setTitle("", for: .normal)
        topBarCurrencyButton.addTarget(self, action: #selector(SendTokensViewController.currencyButtonPressed), for: .touchUpInside)
        topBarCurrencyButton.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.right.equalTo(topBarBackgroundView.snp.right).offset(-10)
        }
        
        // Form Elements
        
        view.addSubview(scanQRCodeButton)
        scanQRCodeButton.addTarget(self, action: #selector(SendTokensViewController.scanButtonPressed), for: .touchUpInside)
        scanQRCodeButton.setBackgroundImage(UIImage(imageLiteralResourceName: "qrCodeIcon"), for: UIControlState.normal);
        scanQRCodeButton.snp.makeConstraints { (make) in
            make.top.equalTo(topBarBackgroundLineView.snp.bottom).offset(10)
            make.centerX.equalTo(topBarBackgroundLineView)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(destinationWalletAddressTextField)
        destinationWalletAddressTextField.placeholder = "Destination Address"
        destinationWalletAddressTextField.title = "Wallet Addres"
        destinationWalletAddressTextField.text = "" //"0x77Ea29731140c0eDeb2D4871Ecdf7fbee0728Da0"
        destinationWalletAddressTextField.returnKeyType = .next
        destinationWalletAddressTextField.tintColor = UIColor.CustomColor.Black.DeepCharcoal
        destinationWalletAddressTextField.selectedTitleColor = UIColor.CustomColor.Grey.midGrey
        destinationWalletAddressTextField.selectedLineColor = UIColor.CustomColor.Grey.midGrey
        destinationWalletAddressTextField.autocapitalizationType = .none
        destinationWalletAddressTextField.keyboardAppearance = .dark
        destinationWalletAddressTextField.keyboardType = UIKeyboardType.default
        destinationWalletAddressTextField.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        destinationWalletAddressTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.centerX.equalTo(view)
            make.top.equalTo(scanQRCodeButton.snp.bottom).offset(10)
        }
        
        view.addSubview(gasLimitTextField)
        gasLimitTextField.placeholder = "0"
        gasLimitTextField.title = "Gas Limit"
        gasLimitTextField.text = "27000"
        gasLimitTextField.returnKeyType = .next
        gasLimitTextField.tintColor = UIColor.CustomColor.Black.DeepCharcoal
        gasLimitTextField.selectedTitleColor = UIColor.CustomColor.Grey.midGrey
        gasLimitTextField.selectedLineColor = UIColor.CustomColor.Grey.midGrey
        gasLimitTextField.autocapitalizationType = .none
        gasLimitTextField.keyboardType = UIKeyboardType.decimalPad
        gasLimitTextField.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        gasLimitTextField.keyboardAppearance = .dark
        gasLimitTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.centerX.equalTo(view)
            make.top.equalTo(destinationWalletAddressTextField.snp.bottom).offset(10)
        }
        
        view.addSubview(coinVolumeTextField)
        coinVolumeTextField.placeholder = "Number of tokens to send"
        coinVolumeTextField.title = "Number to send"
        coinVolumeTextField.text = ""
        coinVolumeTextField.returnKeyType = .next
        coinVolumeTextField.tintColor = UIColor.CustomColor.Black.DeepCharcoal
        coinVolumeTextField.selectedTitleColor = UIColor.CustomColor.Grey.midGrey
        coinVolumeTextField.selectedLineColor = UIColor.CustomColor.Grey.midGrey
        coinVolumeTextField.autocapitalizationType = .none
        coinVolumeTextField.keyboardType = UIKeyboardType.decimalPad
        coinVolumeTextField.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        coinVolumeTextField.keyboardAppearance = .dark
        coinVolumeTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.centerX.equalTo(view)
            make.top.equalTo(gasLimitTextField.snp.bottom).offset(10)
        }
        
        sendButton.backgroundColor = UIColor.black
        sendButton.setTitle("Next", for: .normal)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.addTarget(self, action: #selector(SendTokensViewController.sendButtonPressed), for: .touchUpInside)

        sendButton.addSubview(currentBalanceLabel)
        currentBalanceLabel.text = "Loading balance..."
        currentBalanceLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        currentBalanceLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(sendButton)
            make.bottom.equalTo(sendButton.snp.top).offset(-5)
        }
        
        coinVolumeTextField.inputAccessoryView = sendButton
        destinationWalletAddressTextField.inputAccessoryView = sendButton
        gasLimitTextField.inputAccessoryView = sendButton

        coinVolumeTextField.becomeFirstResponder()
        
        topBarCurrencyButton.setTitle(currentToken?.tokenInfo?.symbol, for: .normal)
        currentBalanceLabel.text = "Current Balance: \(currentToken?.getBalance() ?? 0.0) \(currentToken!.tokenInfo?.symbol ?? "")"
    }
}

extension SendTokensViewController {
    
    @objc func sendButtonPressed(){
    
        var errorPopup: UIAlertController?;
        var sendCoinVolume: Double = 0.0
        var sendGasVolume: Double = 0.0
        var sendDestinationAddress = ""
        
        if let coinVolume = Double(coinVolumeTextField.text!){
            if coinVolume == 0.0{
                errorPopup = UIAlertController(title: "🚨", message: "Enter a number of tokens above zero", preferredStyle: .alert)
            }else{
                sendCoinVolume = coinVolume
            }
        }else{
            errorPopup = UIAlertController(title: "🚨", message: "Enter a number of tokens above zero", preferredStyle: .alert)
        }
        
        if let gasLimit = Double(gasLimitTextField.text!){
            if gasLimit == 0.0 {
                errorPopup = UIAlertController(title: "🚨", message: "Enter a gas limit above zero", preferredStyle: .alert)
            }else{
                sendGasVolume = 0.0
            }
        }else{
            errorPopup = UIAlertController(title: "🚨", message: "Enter a gas limit above zero", preferredStyle: .alert)
        }
        
        if let destinationAddress = destinationWalletAddressTextField.text{
            if destinationAddress.characters.count == 0 {
                errorPopup = UIAlertController(title: "🚨", message: "Enter a destination address", preferredStyle: .alert)
            }else{
                sendDestinationAddress = destinationAddress
            }
        }else{
            errorPopup = UIAlertController(title: "🚨", message: "Enter a destination address", preferredStyle: .alert)
        }
        
        if errorPopup != nil {
            errorPopup?.addAction(UIAlertAction(title: "👍", style: .cancel, handler: nil))
            self.present(errorPopup!, animated: true, completion: nil)
        }else{
            sendTokens(coinVolume: sendCoinVolume, gasLimit: sendGasVolume, destinationAddress: sendDestinationAddress)
        }
    }
    
    func sendTokens(coinVolume: Double, gasLimit: Double, destinationAddress: String){
        
        let isEther = currentToken?.tokenInfo?.symbol == "ETH"
        
        let sendTokensConfrimationViewController = SendTokensConfrimationViewController()
        
        sendTokensConfrimationViewController.setTransactionDetails(isEther: isEther, currentToken: currentToken!, coinVolume: coinVolume, gasLimit: gasLimit, destinationAddress: destinationAddress)

        self.navigationController?.pushViewController(sendTokensConfrimationViewController, animated: true);
    }
    
    @objc func currencyButtonPressed(){
        let selectCurrencyVC = SelectCurrencyViewController()
        selectCurrencyVC.delegate = self
        self.navigationController?.pushViewController(selectCurrencyVC, animated: true)
    }
    
    @objc func scanButtonPressed(){
        let scannerVC = ScannerViewController()
        scannerVC.delegate = self
        let nv = UINavigationController(rootViewController: scannerVC)
        self.present( nv, animated: true, completion: nil)
    }
    
    @objc func closeButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setToken(_ token: ETHToken){
        currentToken = token
        topBarCurrencyButton.setTitle(currentToken?.tokenInfo?.symbol, for: .normal)
        currentBalanceLabel.text = "Your balance: \(currentToken?.getBalance() ?? 0.0) \(currentToken!.tokenInfo?.symbol ?? "")"
    }
}
extension SendTokensViewController: EtherQRScannerProtocol {
    func qrCodeFoundAddress(walletAddress: String) {
        self.destinationWalletAddressTextField.text = walletAddress
    }
}

extension SendTokensViewController: SelectCurrenyProtocol {
    func currencySelected(_ token: ETHToken) {
        setToken(token)
    }
}
