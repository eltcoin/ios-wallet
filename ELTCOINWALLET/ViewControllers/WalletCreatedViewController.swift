//
//  WalletCreatedViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 16/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class WalletCreatedViewController: UIViewController {
    
    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    
    // Wallet Address
    var walletAddressTextField = UITextField()
    
    // Button CTA
    let continueButton = UIButton()
    let exportButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.CustomColor.White.offwhite
        setupViews()
        displayWalletAddress()
    }
    
    func displayWalletAddress(){
        let wallet = WalletManager.sharedInstance.getWalletUnEncrypted()
        walletAddressTextField.text = wallet?.address
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
        topBarTitleLabel.text = "Wallet Created"
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
        
        view.addSubview(walletAddressTextField)
        walletAddressTextField.borderStyle = .none
        walletAddressTextField.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        walletAddressTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(topBarBackgroundLineView.snp.bottom).offset(20)
        }
        
        view.addSubview(continueButton)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = UIColor.CustomColor.Black.DeepCharcoal
        continueButton.layer.cornerRadius = 4.0
        continueButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        continueButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(walletAddressTextField.snp.bottom).offset(20)
        }
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)

        view.addSubview(exportButton)
        exportButton.setTitle("Export Wallet", for: .normal)
        exportButton.setTitleColor(UIColor.CustomColor.Black.DeepCharcoal, for: .normal)
        exportButton.layer.cornerRadius = 4.0
        exportButton.titleLabel?.textColor = UIColor.CustomColor.Black.DeepCharcoal
        exportButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        exportButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(continueButton.snp.bottom).offset(10)
        }
        exportButton.addTarget(self, action: #selector(exportButtonPressed), for: .touchUpInside)
    }
    
    @objc func continueButtonPressed(){
        
        // TODO: getBlockie image
        // globalFuncs.getBlockie = function(address)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func exportButtonPressed(){
        
        let wallet = WalletManager.sharedInstance.getWalletEncrypted()

        let file = "wallet-\(UUID().uuidString).json"
        let text = wallet?.toJSONString(prettyPrint: true)
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            do {
                try text?.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                print("Error writing wallet")
            }
            
            let activityItem:NSURL = NSURL(fileURLWithPath: fileURL.path)
            
            let activityVC = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}


class CustomActivity: UIActivity {
    
    override class var activityCategory: UIActivityCategory {
        return .action
    }
    
    override var activityType: UIActivityType? {
        guard let bundleId = Bundle.main.bundleIdentifier else {return nil}
        return UIActivityType(rawValue: bundleId + "\(self.classForCoder)")
    }
    
    override var activityTitle: String? {
        return "Export Wallet"
    }
    
    override var activityImage: UIImage? {
        return UIImage(imageLiteralResourceName: "iconRound")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {

    }
    
    override func perform() {
        activityDidFinish(true)
    }
}
