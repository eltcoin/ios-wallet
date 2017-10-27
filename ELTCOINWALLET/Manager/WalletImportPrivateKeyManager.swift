//
//  WalletImportPrivateKeyManager.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 18/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import WebKit

class WalletImportPrivateKeyManager: NSObject {
    
    private var webView = WKWebView()
    private var privateKey = ""
    
    private var walletUnEncrypted :WalletUnEncrypted?
    
    public var walletImportCompleted: ((WalletUnEncrypted)->Void)?
    public var errBlock: ((String)->Void)?


    init(privateKey: String, walletImportCompleted: @escaping ((WalletUnEncrypted)->Void), errBlock: @escaping ((String)->Void)) {
        super.init()
        self.walletImportCompleted = walletImportCompleted
        self.errBlock = errBlock
        self.privateKey = privateKey
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
        
        let urlstr = (url?.absoluteString)! + "#view-wallet-info"
        
        print("urlstr: \(urlstr)")
        
        let url2 = URL(string: urlstr)
        
        webView.load(URLRequest(url: url2!))
    }
}

extension WalletImportPrivateKeyManager: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Navigated to: " + (webView.url?.absoluteString)!)
        
        if webView.url?.absoluteString.range(of:"index.html#view-wallet-info") != nil {
            webView.evaluateJavaScript("importWalletWithPrivateKey('\(self.privateKey)')", completionHandler: nil)
        }else{
            webView.evaluateJavaScript("window.location.href = '#view-wallet-info';") { (result, error) in
                webView.evaluateJavaScript("importWalletWithPrivateKey('\(self.privateKey)')", completionHandler: nil)
            }
        }
    }
}

extension WalletImportPrivateKeyManager: WKScriptMessageHandler {
    
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if(message.name == "callbackHandler") {
                
                print("JavaScript is sending a message: \(message.body)")
                let str =  message.body as? String ?? ""
                
                if let parsedData = try? JSONSerialization.jsonObject(with: str.data(using: .utf8)!) as! [String:Any] {
                    print(parsedData)
                    
                    if let tag: String = parsedData["tag"] as? String{
                        switch tag {
                        case WalletManager.WALLET_EVENTS.IMPORTED_WALLET_PK.rawValue:
                            
                            if let walletUnEncryptedJSAPIResponse = WalletUnEncryptedJSAPIResponse(JSONString: str) {
                                self.walletUnEncrypted = walletUnEncryptedJSAPIResponse.payload
                                WalletManager.sharedInstance.setWalletUnEncrypted(wallet: walletUnEncryptedJSAPIResponse.payload)
                                walletImportCompleted!(self.walletUnEncrypted!)
                            }
                            
                        case WalletManager.WALLET_EVENTS.NEW_WALLET_ERR.rawValue:
                            
                            if errBlock != nil {
                                if let errorMessage: String = parsedData["payload"] as? String{
                                    self.errBlock!(errorMessage)
                                }else{
                                    self.errBlock!("There was a problem decrypting your wallet")
                                }
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

