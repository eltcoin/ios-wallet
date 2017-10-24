
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
    
    private var webView = WKWebView()
    private var walletPassword = ""
    private var walletEncrypted :WalletEncrypted?
    private var walletUnEncrypted :WalletUnEncrypted?

    public var walletCreationCompleted: ((WalletEncrypted, WalletUnEncrypted)->Void)?
    public var errBlock: ((String)->Void)?

    init(password: String, walletCreationCompleted: @escaping ((WalletEncrypted, WalletUnEncrypted)->Void), errBlock: @escaping ((String)->Void)) {
        super.init()
        self.walletPassword = password
        self.walletCreationCompleted = walletCreationCompleted
        self.errBlock = errBlock
    }
    
    func createWallet(){
        initiateNewWalletWebview()
    }
    
    func initiateNewWalletWebview(){
        
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
        initiateNewWalletWebview();
        self.walletPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

//MARK: Webview navigation

extension WalletCreationManager: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Navigated to: " + (webView.url?.absoluteString)!)
        
        if webView.url?.absoluteString.range(of:"index.html") != nil {
            webView.evaluateJavaScript("externalGenerateWallet('\(self.walletPassword)')", completionHandler: nil)
        }
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
                    case WalletManager.WALLET_EVENTS.NEW_WALLET_ERR.rawValue:
                        if errBlock != nil {
                            if let errorMessage: String = parsedData["payload"] as? String{
                                self.errBlock!(errorMessage)
                            }else{
                                self.errBlock!("There was a problem creating your wallet")
                            }
                        }
                    case WalletManager.WALLET_EVENTS.NEW_WALLET.rawValue:
                        
                        if let walletUnEncryptedJSAPIResponse = WalletUnEncryptedJSAPIResponse(JSONString: str) {
                            self.walletUnEncrypted = walletUnEncryptedJSAPIResponse.payload
                        }
                        
                    case WalletManager.WALLET_EVENTS.NEW_WALLET_ENC.rawValue:
                        
                        if let walletEncryptedJSAPIResponse = WalletEncryptedJSAPIResponse(JSONString: str) {
                            self.walletEncrypted = walletEncryptedJSAPIResponse.payload
                        }
                        
                    default:
                        let alertController = UIAlertController(title: "New Wallet Error", message:
                            "Sorry, there was a problem creating your wallet", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                        
                        // TODO: Error Callback to code block
                    }
                }
                
                if self.walletUnEncrypted != nil && self.walletEncrypted  != nil {
                    self.walletCreationCompleted!(self.walletEncrypted!, self.walletUnEncrypted!)
                }
            }
        }
    }
}

