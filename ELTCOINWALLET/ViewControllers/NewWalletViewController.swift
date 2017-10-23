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
import WebKit

class NewWalletViewController: UIViewController {
    
    enum WALLET_EVENTS : String {
        case NEW_WALLET_ERR = "NEW_WALLET_ERR",
        NEW_WALLET = "NEW_WALLET",
        NEW_WALLET_ENC = "NEW_WALLET_ENC"
    }
    
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
    
    // Webview for MyEtherWallet
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.CustomColor.White.offwhite
        setupViews()
        setupWebView()
    }
    
    func setupWebView(){
        
        let contentController = WKUserContentController();
        let userScript = WKUserScript(
            source: "redHeader()",
            injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
            forMainFrameOnly: true
        )
        contentController.addUserScript(userScript)
        contentController.add(
            self,
            name: "callbackHandler"
        )
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: CGRect(), configuration: config)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        
        // Disable UI until webview is ready:
        createWalletButton.isEnabled = false
        
        let url = Bundle.main.url(forResource: "dist/index", withExtension: "html")
        webView.load(URLRequest(url: url!))
        
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
        topBarCloseButton.addTarget(self, action: #selector(SendTokensViewController.closeButtonPressed), for: .touchUpInside)
        topBarCloseButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.left.equalTo(topBarBackgroundView.snp.left).offset(10)
        }
        
        // Form inputs
        
        view.addSubview(passwordTextView)
        passwordTextView.placeholder = "Password"
        passwordTextView.title = "Secure Wallet With Password"
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

extension NewWalletViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "callbackHandler") {
            
            print("JavaScript is sending a message: \(message.body)")
            let str =  message.body as? String ?? ""
            
            if let parsedData = try? JSONSerialization.jsonObject(with: str.data(using: .utf8)!) as! [String:Any] {
                print(parsedData)
                
                if let tag: String = parsedData["tag"] as? String{
                    switch tag {
                    case WALLET_EVENTS.NEW_WALLET_ERR.rawValue: break
                    case WALLET_EVENTS.NEW_WALLET.rawValue:
                        
                        if let walletUnEncryptedJSAPIResponse = WalletUnEncryptedJSAPIResponse(JSONString: str) {
                            WalletManager.sharedInstance.setWalletUnEncrypted(wallet: walletUnEncryptedJSAPIResponse.payload)
                        }

                    case WALLET_EVENTS.NEW_WALLET_ENC.rawValue:
                        
                        if let walletEncryptedJSAPIResponse = WalletEncryptedJSAPIResponse(JSONString: str) {
                            WalletManager.sharedInstance.setWalletEncrypted(wallet: walletEncryptedJSAPIResponse.payload)
                        }
                        
                        self.navigationController?.pushViewController(WalletCreatedViewController(), animated: true)

                    default:
                        let alertController = UIAlertController(title: "New Wallet Error", message:
                            "Sorry, there was a problem creating your wallet", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

//MARK: Webview navigation

extension NewWalletViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Navigated to: " + (webView.url?.absoluteString)!)
        createWalletButton.isEnabled = true
    }
}

//MARK: Wallet Functions
extension NewWalletViewController {
    
}

//MARK: Actions
extension NewWalletViewController {
    
    @objc func createWalletButtonPressed(){
        if let password = passwordTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            if webView.url?.absoluteString.range(of:"index.html") != nil {
                webView.evaluateJavaScript("externalGenerateWallet('\(password)')", completionHandler: nil)
            }
        }
    }
    
    @objc func importWalletButtonPressed(){
        self.navigationController?.pushViewController(ImportWalletViewController(), animated: true)
    }
    
    @objc func closeButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}
