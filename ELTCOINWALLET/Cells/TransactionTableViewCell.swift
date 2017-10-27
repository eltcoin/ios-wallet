//
//  TransactionTableViewCell.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 12/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TransactionTableViewCell: UITableViewCell {
    
    let timelineView = UIView()
    let subContentView = UIView()
    
    let cellImageView = UIImageView()
    let cellTitleLabel = UILabel()
    let cellTimeLabel = UILabel()
    let cellAmountLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell(transaction: WalletTransaction){
        
        cellTitleLabel.text = transaction.transactionDate()
        cellTimeLabel.text = transaction.from
        cellAmountLabel.text = "\(transaction.value)"
        
        if transaction.type == .sent {
            let imageSent = UIImage(imageLiteralResourceName: "iconSent") //UIImage.resizeImage(UIImage(imageLiteralResourceName: "iconSent"), 30)
            cellImageView.image = imageSent
            cellImageView.layer.borderColor = UIColor.CustomColor.Red.notificationRed.cgColor
            cellAmountLabel.textColor = UIColor.CustomColor.Red.notificationRed
        }else{
            let imageRec = UIImage(imageLiteralResourceName: "iconRecieved") // UIImage.resizeImage(UIImage(imageLiteralResourceName: "iconRecieved"), 30)
            cellImageView.image = imageRec
            cellImageView.layer.borderColor = UIColor.CustomColor.Green.positiveGreen.cgColor
            cellAmountLabel.textColor = UIColor.CustomColor.Green.positiveGreen
        }
        
        print("strData1: " + transaction.input)
        print("result1: " + hexToStr(text: transaction.input))
    
        var strData2 = String(transaction.input.dropFirst(2))
        print("strData2: " + strData2)
        print("result2: " + hexToStr(text: strData2))
        
    }
    
    func hexToStr(text: String) -> String {
        
        let regex = try! NSRegularExpression(pattern: "(0x)?([0-9A-Fa-f]{2})", options: .caseInsensitive)
        let textNS = text as NSString
        let matchesArray = regex.matches(in: textNS as String, options: [], range: NSMakeRange(0, textNS.length))
        let characters = matchesArray.map {
            Character(UnicodeScalar(UInt32(textNS.substring(with: $0.range(at: 2)), radix: 16)!)!)
        }
        
        return String(characters)
    }
    
    func setupViews(){
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(timelineView)
        timelineView.backgroundColor = UIColor.CustomColor.Grey.lightGrey
        timelineView.snp.makeConstraints { (make) in
            make.width.equalTo(2)
            make.left.equalTo(contentView).offset(10)
            make.top.bottom.equalTo(contentView)
        }
        
        contentView.addSubview(subContentView)
        subContentView.backgroundColor = UIColor.white
        subContentView.layer.borderColor = UIColor.CustomColor.Grey.lightGrey.cgColor
        subContentView.layer.borderWidth = 1
        subContentView.layer.cornerRadius = 4
        subContentView.layer.masksToBounds = true
        subContentView.snp.makeConstraints { (make) in
            make.left.equalTo(timelineView).offset(10)
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
            make.centerY.equalTo(subContentView).offset(-10)
        }
        
        subContentView.addSubview(cellImageView)
        cellImageView.layer.borderWidth =  0 //1
        cellImageView.layer.cornerRadius = 4
        cellImageView.layer.masksToBounds = true
        cellImageView.backgroundColor = UIColor.clear
        cellImageView.contentMode = .scaleAspectFit
        cellImageView.snp.makeConstraints { (make) in
            make.left.equalTo(subContentView).offset(10)
            make.height.width.equalTo(38)
            make.centerY.equalTo(subContentView)
        }
        
        subContentView.addSubview(cellTitleLabel)
        cellTitleLabel.textAlignment = .left
        cellTitleLabel.numberOfLines = 0
        cellTitleLabel.textColor = UIColor.CustomColor.Black.DeepCharcoal
        cellTitleLabel.text = "Transaction Description"
        cellTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        cellTitleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(cellImageView.snp.right).offset(10)
            make.top.equalTo(cellImageView.snp.top)
            make.right.equalTo(cellAmountLabel.snp.rightMargin).offset(-10)
        }
        
        subContentView.addSubview(cellTimeLabel)
        cellTimeLabel.textAlignment = .left
        cellTimeLabel.numberOfLines = 0
        cellTimeLabel.textColor = UIColor.CustomColor.Grey.midGrey
        cellTimeLabel.text = "Wallet Address"
        cellTimeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 11.0)
        cellTimeLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(cellImageView.snp.right).offset(10)
            make.right.equalTo(cellAmountLabel.snp.rightMargin)
            make.top.equalTo(cellTitleLabel.snp.bottom).offset(5)
        }
    }
}
