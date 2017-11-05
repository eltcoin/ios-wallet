//
//  SendTokensConfrimationViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 27/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SkyFloatingLabelTextField
import WebKit
import NVActivityIndicatorView

class SendTokensConfrimationViewController: UIViewController {
    
    let loadingView = UIView()

    // Transaction Details
    var isEther = false;
    var currentToken: ETHToken?
    var coinVolume: Double = 0.0
    var gasLimit: Double = 0.0
    var destinationAddress = ""
    
    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    var topBarCloseButton = UIButton()
    
    // Confirmation Details
    
    var destinationAddressLabel = UILabel()
    var destinationAddressPreview = UILabel()
    
    var tokenVolumeLabel = UILabel()
    var tokenVolumePreview = UILabel()
    
    // Buttons
    let orLabel = UILabel()
    let confirmButton = UIButton()
    let cancelButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.CustomColor.White.offwhite
        setupViews()
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
        topBarTitleLabel.text = "Confirm Transaction"
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
        topBarCloseButton.addTarget(self, action: #selector(SendTokensConfrimationViewController.backButtonPressed), for: .touchUpInside)
        topBarCloseButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.left.equalTo(topBarBackgroundView.snp.left).offset(10)
        }
        
        // Confirmation Details
        
        view.addSubview(destinationAddressLabel)
        destinationAddressLabel.text = "Destination Address"
        destinationAddressLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        destinationAddressLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(topBarBackgroundView.snp.bottom).offset(20)
        }
        view.addSubview(destinationAddressPreview)
        destinationAddressPreview.textAlignment = .center
        destinationAddressPreview.numberOfLines = 0
        destinationAddressPreview.textColor = UIColor.CustomColor.Black.DeepCharcoal
        destinationAddressPreview.text = ""
        destinationAddressPreview.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        destinationAddressPreview.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(topBarBackgroundView)
            make.top.equalTo(destinationAddressLabel.snp.bottom).offset(5)
            make.width.equalTo(topBarBackgroundView)
        }
        
        view.addSubview(tokenVolumeLabel)
        tokenVolumeLabel.text = "# Tokens"
        tokenVolumeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        tokenVolumeLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(destinationAddressPreview.snp.bottom).offset(20)
        }
        view.addSubview(tokenVolumePreview)
        tokenVolumePreview.textAlignment = .center
        tokenVolumePreview.numberOfLines = 0
        tokenVolumePreview.textColor = UIColor.CustomColor.Black.DeepCharcoal
        tokenVolumePreview.text = ""
        tokenVolumePreview.font = UIFont(name: "HelveticaNeue-Medium", size: 22.0)
        tokenVolumePreview.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(topBarBackgroundView)
            make.top.equalTo(tokenVolumeLabel.snp.bottom).offset(5)
            make.width.equalTo(topBarBackgroundView)
        }
        
        // Button
        
        view.addSubview(confirmButton)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitle("Loading...", for: .disabled)
        confirmButton.backgroundColor = UIColor.CustomColor.Black.DeepCharcoal
        confirmButton.layer.cornerRadius = 4.0
        confirmButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        confirmButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(tokenVolumePreview.snp.bottom).offset(20)
        }
        confirmButton.addTarget(self, action: #selector(SendTokensConfrimationViewController.confirmButtonPressed), for: .touchUpInside)
        
        view.addSubview(orLabel)
        orLabel.text = "-or-"
        orLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        orLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(confirmButton.snp.bottom).offset(10)
        }
        
        view.addSubview(cancelButton)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.CustomColor.Black.DeepCharcoal, for: .normal)
        cancelButton.layer.cornerRadius = 4.0
        cancelButton.titleLabel?.textColor = UIColor.CustomColor.Black.DeepCharcoal
        cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        cancelButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(orLabel.snp.bottom).offset(10)
        }
        cancelButton.addTarget(self, action: #selector(SendTokensConfrimationViewController.cancelButtonPressed), for: .touchUpInside)
    
        self.destinationAddressPreview.text = self.destinationAddress
        self.tokenVolumePreview.text = "\(self.coinVolume) \(currentToken?.tokenInfo?.symbol ?? "")"
    }
    
    func setTransactionDetails(isEther: Bool, currentToken: ETHToken, coinVolume: Double, gasLimit: Double, destinationAddress: String){
        self.isEther = isEther
        self.currentToken = currentToken
        self.coinVolume = coinVolume
        self.gasLimit = gasLimit
        self.destinationAddress = destinationAddress
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

//MARK: Actions
extension SendTokensConfrimationViewController {
    
    @objc func confirmButtonPressed(){
        
        self.toggleLoadingState(true)

        let sendTokensManager = WalletSendTokensManager(isEther: isEther, token: currentToken!, coinVolume: coinVolume, gasLimit: gasLimit, destinationAddress: destinationAddress, sendCompleted: {
            self.toggleLoadingState(false)
            let confirmPopup = UIAlertController(title: "Transaction Sent", message: "Your transaction has been uploaded to the Ethereum network for processing", preferredStyle: .alert)
            confirmPopup.addAction(UIAlertAction(title: "👍", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(confirmPopup, animated: true, completion: nil)
            
        }) { (errorMessage) in
            self.toggleLoadingState(false)
            let errorPopup = UIAlertController(title: "🤕", message: errorMessage, preferredStyle: .alert)
            errorPopup.addAction(UIAlertAction(title: "👍", style: .cancel, handler: nil))
            self.present(errorPopup, animated: true, completion: nil)
        }
        
        sendTokensManager.startSending()
    }
    
    @objc func backButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelButtonPressed(){
        
        let confirmPopup = UIAlertController(title: "Cancel Transaction", message: "Do you want to cancel this transaction?", preferredStyle: .alert)
        confirmPopup.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        confirmPopup.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(confirmPopup, animated: true, completion: nil)
    }
}
