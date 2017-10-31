//
//  PINLockViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 31/10/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField

class PINLockViewController: UIViewController {

    let numberPadTopOffset = 60.0
    let buttonSpacing = 20.0
    
    let titleLabel = UILabel()
    
    let previewLabel1 = SkyFloatingLabelTextField(),
        previewLabel2 = SkyFloatingLabelTextField(),
        previewLabel3 = SkyFloatingLabelTextField(),
        previewLabel4 = SkyFloatingLabelTextField()
    
    let btn0 = UIButton(),
        btn1 = UIButton(),
        btn2 = UIButton(),
        btn3 = UIButton(),
        btn4 = UIButton(),
        btn5 = UIButton(),
        btn6 = UIButton(),
        btn7 = UIButton(),
        btn8 = UIButton(),
        btn9 = UIButton(),
        btnDelete = UIButton(),
        bioMetricButton = UIButton()
    
    let btnRadius: CGFloat = 70.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    func setupViews(){
        view.backgroundColor = UIColor.white
        
        // Title
        
        view.addSubview(titleLabel)
        titleLabel.text = "PIN Security"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.CustomColor.Black.DeepCharcoal
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(40)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
        }
        
        // Code entry Preview labels
        
        view.addSubview(previewLabel1)
        view.addSubview(previewLabel2)
        view.addSubview(previewLabel3)
        view.addSubview(previewLabel4)
        
        previewLabel1.isEnabled = false
        previewLabel2.isEnabled = false
        previewLabel3.isEnabled = false
        previewLabel4.isEnabled = false
        
        previewLabel1.textAlignment = .center
        previewLabel2.textAlignment = .center
        previewLabel3.textAlignment = .center
        previewLabel4.textAlignment = .center
        
        previewLabel1.isSecureTextEntry = true
        previewLabel2.isSecureTextEntry = true
        previewLabel3.isSecureTextEntry = true
        previewLabel4.isSecureTextEntry = true
        
        previewLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.width.equalTo(36)
            make.right.equalTo(view.snp.centerX).offset(-10)
        }
        
        previewLabel1.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.width.equalTo(36)
            make.right.equalTo(previewLabel2.snp.left).offset(-20)
        }
        
        previewLabel3.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.width.equalTo(36)
            make.left.equalTo(view.snp.centerX).offset(10)
        }
        
        previewLabel4.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.width.equalTo(36)
            make.left.equalTo(previewLabel3.snp.right).offset(20)
        }
        
        // Code Entry Buttons
        
        for (index, btn) in [btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9, btnDelete].enumerated() {
            view.addSubview(btn)
            btn.tag = index
            btn.layer.borderColor = UIColor.CustomColor.Black.DeepCharcoal.cgColor
            btn.layer.cornerRadius = btnRadius / 2.0
            btn.layer.borderWidth = 1.0
            btn.setTitle("\(index)", for: .normal)
            btn.setTitleColor(UIColor.CustomColor.Black.DeepCharcoal, for: .normal)
            btn.snp.makeConstraints { (make) in
                make.width.height.equalTo(btnRadius)
            }
        }
        btnDelete.setTitle("<", for: .normal)
        
        // First Row
        
        btn2.snp.makeConstraints { (make) in
            make.top.equalTo(previewLabel2.snp.bottom).offset(numberPadTopOffset)
            make.centerX.equalTo(view)
        }
        
        btn1.snp.makeConstraints { (make) in
            make.top.equalTo(previewLabel2.snp.bottom).offset(numberPadTopOffset)
            make.right.equalTo(btn2.snp.left).offset(-buttonSpacing)
        }
        
        btn3.snp.makeConstraints { (make) in
            make.top.equalTo(previewLabel2.snp.bottom).offset(numberPadTopOffset)
            make.left.equalTo(btn2.snp.right).offset(buttonSpacing)
        }
        
        // Second Row
        
        btn5.snp.makeConstraints { (make) in
            make.top.equalTo(btn2.snp.bottom).offset(buttonSpacing)
            make.centerX.equalTo(view)
        }
        
        btn4.snp.makeConstraints { (make) in
            make.top.equalTo(btn2.snp.bottom).offset(buttonSpacing)
            make.right.equalTo(btn2.snp.left).offset(-buttonSpacing)
        }
        
        btn6.snp.makeConstraints { (make) in
            make.top.equalTo(btn2.snp.bottom).offset(buttonSpacing)
            make.left.equalTo(btn2.snp.right).offset(buttonSpacing)
        }
        
        // Third Row
        
        btn8.snp.makeConstraints { (make) in
            make.top.equalTo(btn4.snp.bottom).offset(buttonSpacing)
            make.centerX.equalTo(view)
        }
        
        btn7.snp.makeConstraints { (make) in
            make.top.equalTo(btn4.snp.bottom).offset(buttonSpacing)
            make.right.equalTo(btn8.snp.left).offset(-buttonSpacing)
        }
        
        btn9.snp.makeConstraints { (make) in
            make.top.equalTo(btn4.snp.bottom).offset(buttonSpacing)
            make.left.equalTo(btn8.snp.right).offset(buttonSpacing)
        }
        
        // Fourth Row
        
        btn0.snp.makeConstraints { (make) in
            make.top.equalTo(btn8.snp.bottom).offset(buttonSpacing)
            make.centerX.equalTo(view)
        }
        
        btnDelete.snp.makeConstraints { (make) in
            make.top.equalTo(btn8.snp.bottom).offset(buttonSpacing)
            make.left.equalTo(btn0.snp.right).offset(buttonSpacing)
        }
    }
}
