//
//  HomeViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 12/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController: UIViewController {

    // Member vars
    let reuseIdentifier = "TransactionCell"
    var walletTransactions = TransactionsDataStub.transactions()
    
    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarLogoImageView = UIImageView()
    var topBarSettingsButton = UIButton()
    var topBarSendButton = UIButton()
    var topBarBackgroundLineView = UIView()
    
    // WALLET SUMMARY
    var walletSummaryBackgroundView = UIView()
    var walletSummaryBackgroundLineView = UIView()
    var walletAvatarButton = UIButton()
    var walletAddressLabel = UILabel()
    var walletBalanceLabel = UILabel()
    var walletFiatBalanceLabel = UILabel()

    // Transaction List
    var transactionsTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        // TOP VIEWS

        self.view.addSubview(topBarBackgroundView)
        topBarBackgroundView.snp.makeConstraints { (make) in
            make.height.equalTo(64)
            make.top.centerX.width.equalTo(view)
        }
        
        topBarBackgroundView.addSubview(topBarLogoImageView)
        topBarLogoImageView.image = UIImage(imageLiteralResourceName: "logoText")
        topBarLogoImageView.contentMode = .scaleAspectFit
        topBarLogoImageView.snp.makeConstraints { (make) in
            make.height.equalTo(topBarBackgroundView).offset(-20)
            make.width.equalTo(topBarBackgroundView)
            make.centerX.equalTo(topBarBackgroundView)
            make.top.equalTo(topBarBackgroundView).offset(20)
        }
        
        topBarBackgroundView.addSubview(topBarBackgroundLineView)
        topBarBackgroundLineView.backgroundColor = UIColor.CustomColor.Grey.lightGrey
        topBarBackgroundLineView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(view)
            make.top.equalTo(topBarBackgroundView.snp.bottom)
            make.height.equalTo(1)
        }
        
        topBarBackgroundView.addSubview(topBarSettingsButton)
        topBarSettingsButton.setBackgroundImage(UIImage(imageLiteralResourceName: "settingIcon"), for: UIControlState.normal);
        topBarSettingsButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.right.equalTo(topBarBackgroundView.snp.right).offset(-10)
        }
        
        topBarBackgroundView.addSubview(topBarSendButton)
        topBarSendButton.setBackgroundImage(UIImage(imageLiteralResourceName: "iconSent"), for: UIControlState.normal);
        topBarSendButton.addTarget(self, action: #selector(HomeViewController.openSendModel), for: .touchUpInside)
        topBarSendButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.left.equalTo(topBarBackgroundView.snp.left).offset(10)
        }
        
        // WALLET SUMMARY
        
        self.view.addSubview(walletSummaryBackgroundView)
        walletSummaryBackgroundView.backgroundColor = UIColor.CustomColor.White.offwhite
        walletSummaryBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(topBarBackgroundView.snp.bottom)
            make.height.equalTo(230)
            make.centerX.equalTo(view)
            make.width.equalTo(view)
        }
        
        walletSummaryBackgroundView.addSubview(walletAvatarButton)
        walletAvatarButton.setBackgroundImage(UIImage(imageLiteralResourceName: "exampleWalletAvatar"), for: .normal)
        walletAvatarButton.addTarget(self, action: #selector(HomeViewController.attachWallet), for: .touchUpInside)
        walletAvatarButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalTo(view)
            make.top.equalTo(walletSummaryBackgroundView).offset(20)
        }
        
        walletSummaryBackgroundView.addSubview(walletAddressLabel)
        walletAddressLabel.textAlignment = .center
        walletAddressLabel.font = UIFont.systemFont(ofSize: 12)
        walletAddressLabel.text = "0x93a408E47dBD8F1566316BFdE3BCC7DFe5FD8224"
        walletAddressLabel.textColor = UIColor.CustomColor.Grey.midGrey
        walletAddressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(walletAvatarButton.snp.bottom).offset(10)
            make.width.equalTo(walletSummaryBackgroundView)
            make.centerX.equalTo(view)
        }
        
        walletSummaryBackgroundView.addSubview(walletBalanceLabel)
        walletBalanceLabel.textAlignment = .center
        walletBalanceLabel.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.bold)
        walletBalanceLabel.text = "12.36893689"
        walletBalanceLabel.textColor = UIColor.black
        walletBalanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(walletAddressLabel.snp.bottom).offset(5)
            make.width.equalTo(walletSummaryBackgroundView)
            make.centerX.equalTo(view)
        }
        
        walletSummaryBackgroundView.addSubview(walletFiatBalanceLabel)
        walletFiatBalanceLabel.textAlignment = .center
        walletFiatBalanceLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        walletFiatBalanceLabel.text = "12.36 USD"
        walletFiatBalanceLabel.textColor = UIColor.black
        walletFiatBalanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(walletBalanceLabel.snp.bottom).offset(5)
            make.width.equalTo(walletSummaryBackgroundView)
            make.centerX.equalTo(view)
        }
        
        walletSummaryBackgroundView.addSubview(walletSummaryBackgroundLineView)
        walletSummaryBackgroundLineView.backgroundColor = UIColor.CustomColor.Grey.lightGrey
        walletSummaryBackgroundLineView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(view)
            make.bottom.equalTo(walletSummaryBackgroundView.snp.bottom).offset(-1)
            make.height.equalTo(1)
        }
        
        // Transaction List
        view.addSubview(transactionsTableView)
        transactionsTableView.separatorStyle = .none
        transactionsTableView.backgroundColor = UIColor.clear
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
        transactionsTableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        transactionsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(walletSummaryBackgroundView.snp.bottom).offset(1)
            make.width.bottom.equalTo(view)
            //make.centerX.equalTo(view)
        }
        
    }
    
    @objc func attachWallet(){
        
        let newWalletViewController = NewWalletViewController()
        newWalletViewController.hidesBottomBarWhenPushed = true
        
        let navController = PopupNavigationController(rootViewController: newWalletViewController)
        navController.navigationBar.isTranslucent = true
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .custom
        
        self.present(navController, animated: true)
    }
    
    @objc func openSendModel(){
        
        let sendCoinViewController = SendCoinViewController()
        sendCoinViewController.hidesBottomBarWhenPushed = true

        let navController = PopupNavigationController(rootViewController: sendCoinViewController)
        navController.navigationBar.isTranslucent = true
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .custom
 
        self.present(navController, animated: true)
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TransactionTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TransactionTableViewCell
        
        cell.setupCell(transaction: walletTransactions[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletTransactions.count;
    }
    
}