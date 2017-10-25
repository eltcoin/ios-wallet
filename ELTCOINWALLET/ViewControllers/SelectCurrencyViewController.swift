//
//  SelectCurrencyViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 25/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//


import Foundation
import UIKit
import SnapKit

protocol SelectCurrenyProtocol {
    func currencySelected(_ token: ETHToken)
}

class SelectCurrencyViewController: UIViewController {
    
    var delegate: SelectCurrenyProtocol?
    var tokens = [ETHToken]()
    let reuseIdentifier = "CURRENCY_CELL_IDENTIFIER"
    
    // TOP BAR
    var topBarBackgroundView = UIView()
    var topBarTitleLabel = UILabel()
    var topBarBackgroundLineView = UIView()
    var topBarCancelButton = UIButton()
    var topBarETHButton = UIButton()

    // Form Elements
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.CustomColor.White.offwhite
        
        setupViews()
        setupTableData()
    }
    
    func setupTableData(){

        let walletManager = WalletTransactionsManager()
        
        walletManager.getBalance(balanceImportCompleted: { (walletBalance) in
            self.tokens = walletBalance.tokens ?? [ETHToken]()
            self.tableView.reloadData()
        })
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
        topBarTitleLabel.text = "Select Currency"
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
        
        topBarBackgroundView.addSubview(topBarETHButton)
        topBarETHButton.contentHorizontalAlignment = .right
        topBarETHButton.setTitleColor(UIColor.black, for: .normal)
        topBarETHButton.setTitle("ETH", for: .normal)
        topBarETHButton.addTarget(self, action: #selector(SelectCurrencyViewController.ETHButtonPressed), for: .touchUpInside)
        topBarETHButton.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(28)
            make.top.equalTo(topBarBackgroundView).offset(25)
            make.right.equalTo(topBarBackgroundView.snp.right).offset(-10)
        }
        
        // Table View
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(topBarBackgroundView.snp.bottom)
        }
    }
    
    @objc func cancelButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ETHButtonPressed(){
        let token = ETHToken()
        token.tokenInfo = ETHTokenInfo()
        token.tokenInfo?.symbol = "ETH"
        token.tokenInfo?.name = "Ethereum"
        
        if delegate != nil {
            delegate?.currencySelected(token)
            self.navigationController?.popViewController(animated: true)
        }    }
}

extension SelectCurrencyViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let token = self.tokens[indexPath.row]
        
        cell.textLabel?.text = token.tokenInfo?.symbol
        cell.detailTextLabel?.text = token.tokenInfo?.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let token = self.tokens[indexPath.row]
        
        if delegate != nil {
            delegate?.currencySelected(token)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokens.count;
    }
}

