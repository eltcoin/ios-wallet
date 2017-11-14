//
//  MenuViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 01/11/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import FCAlertView

class MenuViewController: UIViewController {
    
    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    var topBarCloseButton = UIButton()
    
    let reuseIdentifier = "MenuItemCellIdentifier"
    let tableview = UITableView()
    
    var menuItems = [MenuItem]()
    
    enum MENU_ITEM_TAG : Int {
        case SETUP_PIN = 0,
        SWITCH_WALLET = 1,
        EXPORT_WALLET = 2,
        LOGOUT = 3,
        LOCK = 4,
        COPY_ADDRESS_CLIPBOARD = 5,
        ELTCOIN_WEBSITE = 6
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupMenuItems()
    }
    
    func setupMenuItems(){
        
        let savedPIN = UserDefaults.standard.string(forKey: "PIN")
        
        if savedPIN != nil && savedPIN?.count == 4 {
            menuItems.append(
                MenuItem(menuItemTitle: "Lock App",
                         menuItemTag: MENU_ITEM_TAG.LOCK.rawValue))
            menuItems.append(
                MenuItem(menuItemTitle: "Update PIN",
                         menuItemTag: MENU_ITEM_TAG.SETUP_PIN.rawValue))
        }else{
            menuItems.append(
                MenuItem(menuItemTitle: "Setup PIN",
                         menuItemTag: MENU_ITEM_TAG.SETUP_PIN.rawValue))
        }
        
        menuItems.append(
            MenuItem(menuItemTitle: "Switch Wallet",
                     menuItemTag: MENU_ITEM_TAG.SWITCH_WALLET.rawValue))
        menuItems.append(
            MenuItem(menuItemTitle: "Export Wallet",
                     menuItemTag: MENU_ITEM_TAG.EXPORT_WALLET.rawValue))
        menuItems.append(
            MenuItem(menuItemTitle: "Copy Wallet Address",
                     menuItemTag: MENU_ITEM_TAG.COPY_ADDRESS_CLIPBOARD.rawValue))
        
        menuItems.append(
            MenuItem(menuItemTitle: "ELTCOIN Website",
                     menuItemTag: MENU_ITEM_TAG.ELTCOIN_WEBSITE.rawValue))
        
        menuItems.append(
            MenuItem(menuItemTitle: "Logout",
                     menuItemTag: MENU_ITEM_TAG.LOGOUT.rawValue))
        
        tableview.reloadData()
    }
    
    func setupViews(){
        self.view.backgroundColor = UIColor.white
        
        // TOP VIEWS
        
        let topOffset = UIDevice.current.iPhoneX ? 20 : 0
        
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
        topBarTitleLabel.text = "Menu"
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
        topBarCloseButton.addTarget(self, action: #selector(ImportWalletPKViewController.closeButtonPressed), for: .touchUpInside)
        topBarCloseButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.left.equalTo(topBarBackgroundView.snp.left).offset(10)
        }
        
        // Menu Tableview
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableview.snp.makeConstraints { (make) in
            make.width.bottom.equalTo(view)
            make.top.equalTo(topBarBackgroundLineView.snp.bottom)
        }
    }
}

extension MenuViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = menuItems[indexPath.row].menuItemTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // TODO: Menu Action
        let menuItem = menuItems[indexPath.row]
        
        switch menuItem.menuItemTag {
            case MENU_ITEM_TAG.LOCK.rawValue: lockApp()
            case MENU_ITEM_TAG.SETUP_PIN.rawValue: setupPIN()
            case MENU_ITEM_TAG.SWITCH_WALLET.rawValue:  attachWallet()
            case MENU_ITEM_TAG.EXPORT_WALLET.rawValue: exportWallet()
            case MENU_ITEM_TAG.LOGOUT.rawValue: logoutPrompt()
            case MENU_ITEM_TAG.ELTCOIN_WEBSITE.rawValue: openEltCoinWebsite();
            case MENU_ITEM_TAG.COPY_ADDRESS_CLIPBOARD.hashValue: copyAddressToClipboard()
            default: break;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count;
    }
}

extension MenuViewController {
    
    @objc func closeButtonPressed(){
        if presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func openEltCoinWebsite(){
        if let url = NSURL(string: "https://eltcoin.tech"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func copyAddressToClipboard(){
        if let wallet = WalletManager.sharedInstance.getWalletUnEncrypted(){
            if wallet.address.count > 0 {
                let pasteboard = UIPasteboard.general
                pasteboard.string = wallet.address
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func lockApp(){
        UserDefaults.standard.removeObject(forKey: "EXIT_DATE")
        UserDefaults.standard.removeObject(forKey: "UNLOCK_DATE")
        UserDefaults.standard.synchronize()
        PINLockViewController().checkPINDisplay()
    }
    
    func logoutPrompt(){
        let alert = FCAlertView()
        
        alert.doneActionBlock {
            self.logout()
        }
        
        alert.showAlert(inView: self,
                        withTitle: "Logout",
                        withSubtitle: "Are you sure you logout and remove your wallet from this device?",
                        withCustomImage: nil,
                        withDoneButtonTitle: "OK",
                        andButtons: ["Cancel"])
    }
    
    func logout(){
        WalletManager.sharedInstance.deleteWallet()
                
        if presentingViewController != nil {
            self.dismiss(animated: false, completion: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOGOUT"), object: self, userInfo: nil)
            })
        }else{
            self.navigationController?.popViewController(animated: false)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOGOUT"), object: self, userInfo: nil)
        }
    }
    
    func setupPIN(){
        self.present(PINLockViewController(), animated: true)
    }
    
    func attachWallet(){
        
        let alert = FCAlertView()
        
        alert.doneActionBlock {
            let newWalletViewController = NewWalletViewController()
            newWalletViewController.hidesBottomBarWhenPushed = true
            
            let navController = PopupNavigationController(rootViewController: newWalletViewController)
            navController.navigationBar.isTranslucent = true
            navController.navigationBar.isHidden = true
            navController.modalPresentationStyle = .custom
            
            self.present(navController, animated: true)
        }
        
        alert.showAlert(inView: self,
                        withTitle: "Switch Wallet",
                        withSubtitle: "Are you sure you want to remove your wallet from this device and to swap to another?",
                        withCustomImage: nil,
                        withDoneButtonTitle: "OK",
                        andButtons: ["Cancel"])
    }
    
    func exportWallet(){
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

