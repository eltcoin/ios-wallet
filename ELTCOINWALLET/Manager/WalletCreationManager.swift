
//
//  WalletCreationManager.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 18/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import WebKit

class WalletCreationManager : NSObject {
    
    enum WALLET_EVENTS : String {
        case NEW_WALLET_ERR = "NEW_WALLET_ERR",
        NEW_WALLET = "NEW_WALLET",
        NEW_WALLET_ENC = "NEW_WALLET_ENC"
    }
    
    // Webview for MyEtherWallet
    var webView = WKWebView()
    
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
    
        let url = Bundle.main.url(forResource: "dist/index", withExtension: "html")
        webView.load(URLRequest(url: url!))
    }
}


//MARK: Actions
extension WalletCreationManager {
    
    @objc func createWallet(password: String){
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        if webView.url?.absoluteString.range(of:"index.html") != nil {
            webView.evaluateJavaScript("externalGenerateWallet('\(trimmedPassword)')", completionHandler: nil)
        }
    }
}

//MARK: Webview navigation

extension WalletCreationManager: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Navigated to: " + (webView.url?.absoluteString)!)
    }
}

extension WalletCreationManager: WKScriptMessageHandler {
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
                        
                        // TODO: Callback to code block
                    case WALLET_EVENTS.NEW_WALLET_ENC.rawValue:
                        
                        if let walletEncryptedJSAPIResponse = WalletEncryptedJSAPIResponse(JSONString: str) {
                            WalletManager.sharedInstance.setWalletEncrypted(wallet: walletEncryptedJSAPIResponse.payload)
                        }
                        
                    // TODO: Callback to code block
                    default:
                        let alertController = UIAlertController(title: "New Wallet Error", message:
                            "Sorry, there was a problem creating your wallet", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                        
                        // TODO: Callback to code block
                    }
                }
            }
        }
    }
}

