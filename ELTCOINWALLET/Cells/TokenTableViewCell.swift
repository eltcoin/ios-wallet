//
//  CurrencyTableViewCell.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 25/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//


import Foundation
import UIKit
import SnapKit

class TokenTableViewCell: UITableViewCell {
    
    let subContentView = UIView()
    
    let cellSymbolLabel = UILabel()
    let cellTitleLabel = UILabel()
    let cellAmountLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell(token: ETHToken){
        cellTitleLabel.text = "" // token.tokenInfo?.name ?? "Unkown"
        cellAmountLabel.text = String(format:"%0.f %@", (token.getBalance()), token.tokenInfo?.symbol ?? "")
        cellSymbolLabel.text = token.tokenInfo?.symbol ?? "Unkown"
    }
    
    func setupViews(){
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(subContentView)
        subContentView.backgroundColor = UIColor.white
        subContentView.layer.borderColor = UIColor.CustomColor.Grey.lightGrey.cgColor
        subContentView.layer.borderWidth = 1
        subContentView.layer.cornerRadius = 4
        subContentView.layer.masksToBounds = true
        subContentView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.height.equalTo(64)
            make.right.equalTo(contentView).offset(-10)
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
        }
        
        subContentView.addSubview(cellAmountLabel)
        cellAmountLabel.textAlignment = .right
        cellAmountLabel.numberOfLines = 1
        cellAmountLabel.textColor = UIColor.CustomColor.Black.DeepCharcoal
        cellAmountLabel.text = "+1.7654322"
        cellAmountLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 18.0)
        cellAmountLabel.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(subContentView.snp.rightMargin).offset(0)
            make.centerY.equalTo(subContentView)
        }
        
        subContentView.addSubview(cellSymbolLabel)
        cellSymbolLabel.textAlignment = .left
        cellSymbolLabel.numberOfLines = 1
        cellSymbolLabel.textColor = UIColor.CustomColor.Black.DeepCharcoal
        cellSymbolLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 24.0)
        cellSymbolLabel.snp.makeConstraints { (make) in
            make.left.equalTo(subContentView).offset(10)
            make.height.equalTo(38)
            //make.width.equalTo(120)
            make.centerY.equalTo(subContentView)
        }
        
        subContentView.addSubview(cellTitleLabel)
        cellTitleLabel.textAlignment = .left
        cellTitleLabel.numberOfLines = 0
        cellTitleLabel.textColor = UIColor.CustomColor.Black.DeepCharcoal
        cellTitleLabel.text = "Transaction Description"
        cellTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        cellTitleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(cellSymbolLabel.snp.right).offset(10)
            make.top.equalTo(cellSymbolLabel.snp.top).offset(10)
            make.right.equalTo(cellAmountLabel.snp.rightMargin).offset(-10)
        }
        
    }
}

