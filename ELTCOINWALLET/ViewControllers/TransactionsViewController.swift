//
//  TransactionsViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 26/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TransactionsViewController: UIViewController {
    
    var token: ETHToken?
    
    // Table Data
    let reuseIdentifier = "TransactionCell"
    var walletTransactions = [WalletTransaction]()

    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    var topBarCancelButton = UIButton()
    
    // Form Elements
    let tableView = UITableView()
    
    // Empty Transaction List Label
    var emptyListLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.CustomColor.White.offwhite
        
        setupViews()
        setupTableData()
    }
    
    func setupTableData(){
        
        let walletManager = WalletTransactionsManager()
        
        if let currentToken = self.token {
            topBarTitleLabel.text = "\(self.token?.tokenInfo?.symbol ?? "Token") Transactions"

            walletManager.getTokenTransactions(token:(currentToken.tokenInfo)!, transactionsImportCompleted: { (transactions) in
                self.walletTransactions = transactions
                self.emptyListLabel.isHidden = self.walletTransactions.count > 0
                self.tableView.reloadData()
            })
        }else{
            topBarTitleLabel.text = "Ether Transactions"

            walletManager.getEtherTransactions(transactionsImportCompleted: { (transactions) in
                self.walletTransactions = transactions
                self.emptyListLabel.isHidden = self.walletTransactions.count > 0
                self.tableView.reloadData()
            })
        }
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
        topBarTitleLabel.text = "Transactions"
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
        
        topBarBackgroundView.addSubview(topBarCancelButton)
        topBarCancelButton.contentHorizontalAlignment = .left
        topBarCancelButton.setTitleColor(UIColor.black, for: .normal)
        topBarCancelButton.setTitle("Cancel", for: .normal)
        topBarCancelButton.addTarget(self, action: #selector(SelectCurrencyViewController.cancelButtonPressed), for: .touchUpInside)
        topBarCancelButton.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.left.equalTo(topBarBackgroundView.snp.left).offset(10)
        }
        
        // Table View
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(topBarBackgroundView.snp.bottom)
        }
        
        view.addSubview(emptyListLabel)
        emptyListLabel.text = "There's no transactions to show\n😥"
        emptyListLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        emptyListLabel.numberOfLines = 0
        emptyListLabel.isHidden = true
        emptyListLabel.textAlignment = .center
        emptyListLabel.snp.makeConstraints { (make) in
            make.margins.equalTo(tableView)
        }
    }
    
    @objc func cancelButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension TransactionsViewController : UITableViewDelegate, UITableViewDataSource {
    
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
