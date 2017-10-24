//
//  ImportWalletViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 18/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ImportWalletViewController: UIViewController {
    
    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    var topBarCloseButton = UIButton()
    
    // Import Wallet Options - Buttons
    let selectKeystoreFileButton = UIButton()
    let inputPrivateKeyButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.view.backgroundColor = UIColor.white
        
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
        topBarTitleLabel.text = "Import Wallet"
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
        topBarCloseButton.addTarget(self, action: #selector(ImportWalletViewController.closeButtonPressed), for: .touchUpInside)
        topBarCloseButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.left.equalTo(topBarBackgroundView.snp.left).offset(10)
        }
        
        // Button Options
        
        view.addSubview(selectKeystoreFileButton)
        selectKeystoreFileButton.setTitle("Select Keystore File", for: .normal)
        selectKeystoreFileButton.backgroundColor = UIColor.CustomColor.Black.DeepCharcoal
        selectKeystoreFileButton.layer.cornerRadius = 4.0
        selectKeystoreFileButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        selectKeystoreFileButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(topBarBackgroundLineView.snp.bottom).offset(50)
        }
        selectKeystoreFileButton.addTarget(self, action: #selector(ImportWalletViewController.selectKeystoreButtonPressed), for: .touchUpInside)
        
        view.addSubview(inputPrivateKeyButton)
        inputPrivateKeyButton.setTitle("Enter Private Key", for: .normal)
        inputPrivateKeyButton.backgroundColor = UIColor.CustomColor.Black.DeepCharcoal
        inputPrivateKeyButton.layer.cornerRadius = 4.0
        inputPrivateKeyButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        inputPrivateKeyButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(selectKeystoreFileButton.snp.bottom).offset(20)
        }
        inputPrivateKeyButton.addTarget(self, action: #selector(ImportWalletViewController.inputPrivateKeyButtonPressed), for: .touchUpInside)
        
    }
}

extension ImportWalletViewController : UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        print("The Url is : \(cico)")
        
        if let jsonString = try? String(contentsOf: url, encoding: String.Encoding.utf8){
            print("Read JSON file:")
            print(jsonString)
            
        }
        
        //optional, case PDF -> render
        //displayPDFweb.loadRequest(NSURLRequest(url: cico) as URLRequest)
    }
    func documentMenu(_ documentMenu:     UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        print("we cancelled")
        dismiss(animated: true, completion: nil)
    }
}

extension ImportWalletViewController {
    
    @objc func inputPrivateKeyButtonPressed(){
        self.navigationController?.pushViewController(ImportWalletPKViewController(), animated: true)
    }
    
    @objc func selectKeystoreButtonPressed(){
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    @objc func closeButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}
