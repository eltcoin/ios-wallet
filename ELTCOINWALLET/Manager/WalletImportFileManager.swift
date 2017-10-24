//
//  WalletImportFileManager.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 24/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//


import Foundation
import WebKit

class WalletImportFileManager: NSObject {
    
    private var webView = WKWebView()
    private var fileContent = ""
    private var password = ""
    
    private var walletUnEncrypted :WalletUnEncrypted?
    
    public var walletImportCompleted: ((WalletUnEncrypted)->Void)?
    public var errBlock: ((String)->Void)?

    init(password: String, fileContent: String, walletImportCompleted: @escaping ((WalletUnEncrypted)->Void), errBlock: @escaping ((String)->Void)) {
        super.init()
        self.walletImportCompleted = walletImportCompleted
        self.errBlock = errBlock
        self.password = password
        self.fileContent = fileContent
    }
    
    func startImport(){
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

extension WalletImportFileManager: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Navigated to: " + (webView.url?.absoluteString)!)
        
        if webView.url?.absoluteString.range(of:"index.html#view-wallet-info") != nil {
            webView.evaluateJavaScript("importWalletWithKeyStoreFile('\(self.fileContent)', '\(self.password)')", completionHandler: nil)
        }
    }
}

extension WalletImportFileManager: WKScriptMessageHandler {
    
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
                    case WalletManager.WALLET_EVENTS.IMPORTED_WALLET_FILE.rawValue:
                        
                        if let walletUnEncryptedJSAPIResponse = WalletUnEncryptedJSAPIResponse(JSONString: str) {
                            self.walletUnEncrypted = walletUnEncryptedJSAPIResponse.payload
                            walletImportCompleted!(self.walletUnEncrypted!)
                        }
                        
                    default:
                        if errBlock != nil {
                            self.errBlock!("There was a problem decrypting your keystore file")
                        }
                    }
                }
                
            }
        }
    }
}
