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
import LocalAuthentication
import AudioToolbox
import FCAlertView

class PINLockViewController: UIViewController {

    enum PIN_ACTION {
        case AUTHENTICATION
        case SETUP
    }
    
    let numberPadTopOffset = 60.0
    let buttonSpacing = 16.0
    let btnRadius: CGFloat = 70.0
    let TRIES_REMAINING_KEY = "TRIES_REMAINING"
    var cachedCode: String = ""
    var currentCode: String = ""
    var currentAction = PIN_ACTION.SETUP
    var triesRemaining = 3
    var context = LAContext() // For TouchID
    var policy: LAPolicy?
    
    let titleLabel = UILabel(),
        subTitleLabel = UILabel()
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
        bioMetricButton = UIButton(),
        btnTouchID = UIButton(),
        btnCancel = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    func setupViews(){
        view.backgroundColor = UIColor.white
        
        loadTriesRemaining()
        
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
        
        view.addSubview(subTitleLabel)
        subTitleLabel.text = ""
        subTitleLabel.textAlignment = .center
        subTitleLabel.textColor = UIColor.CustomColor.Grey.midGrey
        subTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
        }
        
        // Code entry Preview labels
        
        for (_, labelView) in [previewLabel1, previewLabel2, previewLabel3, previewLabel4].enumerated() {
            view.addSubview(labelView)
            labelView.isEnabled = false
            labelView.textAlignment = .center
            labelView.isSecureTextEntry = true
        }
        
        previewLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(50)
            make.width.equalTo(36)
            make.right.equalTo(view.snp.centerX).offset(-10)
        }
        
        previewLabel1.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(50)
            make.width.equalTo(36)
            make.right.equalTo(previewLabel2.snp.left).offset(-20)
        }
        
        previewLabel3.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(50)
            make.width.equalTo(36)
            make.left.equalTo(view.snp.centerX).offset(10)
        }
        
        previewLabel4.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(50)
            make.width.equalTo(36)
            make.left.equalTo(previewLabel3.snp.right).offset(20)
        }
        
        // Code Entry Buttons
        
        for (index, btn) in [btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9, btnDelete, btnTouchID].enumerated() {
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
            if index < 10 {
                btn.addTarget(self, action: #selector(numberButtonPressed(_:)), for: .touchUpInside)
            }
        }
        
        btnDelete.setTitle("<", for: .normal)
        btnDelete.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        btnTouchID.setImage(UIImage(imageLiteralResourceName:"touchIDIcon"), for: .normal)
        btnTouchID.addTarget(self, action: #selector(touchIDButtonPressed(_:)), for: .touchUpInside)
        btnCancel.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
        
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
        
        btnTouchID.snp.makeConstraints { (make) in
            make.top.equalTo(btn7.snp.bottom).offset(buttonSpacing)
            make.right.equalTo(btn8.snp.left).offset(-buttonSpacing)
        }
        
        btnDelete.snp.makeConstraints { (make) in
            make.top.equalTo(btn8.snp.bottom).offset(buttonSpacing)
            make.left.equalTo(btn0.snp.right).offset(buttonSpacing)
        }
        
        // Cancel Button
        view.addSubview(btnCancel)
        btnCancel.setTitleColor(UIColor.CustomColor.Black.DeepCharcoal, for: .normal)
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-5)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTouchID()
        
        if triesRemaining < 1 {
            let alert = FCAlertView()
            
            alert.doneActionBlock {
                self.resetPIN()
            }
            
            alert.showAlert(inView: self,
                            withTitle: "Access Denied",
                            withSubtitle: "You have used up all 3 access attempts, so your account will be logged out.",
                            withCustomImage: nil,
                            withDoneButtonTitle: "Ok",
                            andButtons: nil)
        }
    }
    
    func loadTriesRemaining(){
        if UserDefaults.standard.object(forKey: TRIES_REMAINING_KEY) != nil {
            self.triesRemaining = UserDefaults.standard.integer(forKey: TRIES_REMAINING_KEY)
        }
    }
    
    //MARK: Actions
    
    @objc func numberButtonPressed(_ sender: UIButton) {
        
        print("\(sender.tag) button pressed")
        
        currentCode = currentCode + "\(sender.tag)"
        
        if currentCode.count == 4 {
            processPIN()
        }
        
        prettyCodePrint()
    }
    
    @objc func cancelButtonPressed(_ sender: Any) {
        
        if currentAction == PIN_ACTION.AUTHENTICATION {
            
            let alert = FCAlertView()
            
            alert.doneActionBlock {
                self.resetPIN()
            }
            
            alert.showAlert(inView: self,
                            withTitle: "Reset PIN",
                            withSubtitle: "Resetting your PIN will log you out. Do you wish to continue?",
                            withCustomImage: nil,
                            withDoneButtonTitle: "Continue",
                            andButtons: ["Cancel"])
            
            
        }
        else if currentAction == PIN_ACTION.SETUP {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func deleteButtonPressed(_ sender: Any) {
        if currentCode.count > 0 {
            let endIndex = currentCode.index(currentCode.endIndex, offsetBy: -1)
            currentCode = currentCode.substring(to: endIndex)
        }
        prettyCodePrint()
    }
    
    @objc func touchIDButtonPressed(_ sender: Any) {
        processTouchID()
    }
    
    //MARK: Functions
    
    func processPIN(){
        if currentAction == PIN_ACTION.AUTHENTICATION {
            
            let savedPIN = UserDefaults.standard.string(forKey: "PIN")
            
            if savedPIN != nil && savedPIN == currentCode {
                self.PINSuccess()
            }else{
                triesRemaining -= 1
                UserDefaults.standard.set(triesRemaining, forKey: TRIES_REMAINING_KEY)
                UserDefaults.standard.synchronize()
                
                currentCode = ""
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                if(triesRemaining == 0){
                    let alert = FCAlertView()
                    
                    alert.doneActionBlock {
                        self.resetPIN()
                    }
                    
                    alert.showAlert(inView: self,
                                    withTitle: "Access Denied",
                                    withSubtitle: "You have used up all 3 access attempts, so your account will be logged out.",
                                    withCustomImage: nil,
                                    withDoneButtonTitle: "Ok",
                                    andButtons: nil)
                }else{
                    subTitleLabel.text = "\(triesRemaining) tries remaining"
                }
            }
            
        }
        else if currentAction == PIN_ACTION.SETUP {
            // Setting up PIN
            
            if cachedCode == "" {
                cachedCode = currentCode
                currentCode = ""
                subTitleLabel.text = "Step 2 of 2 (Confirm PIN)"
            }else{
                if currentCode == cachedCode {
                    UserDefaults.standard.set(currentCode, forKey: "PIN")
                    if presentingViewController != nil {
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    subTitleLabel.text = "Retrying, step 1 of 2"
                    cachedCode = ""
                    currentCode = ""
                }
            }
        }else{
            print("Current action not defined, doing nothing.")
        }
    }
    
    func prettyCodePrint(){
        
        print ("starting pretty print with code: \(currentCode)")
        
        for (i, previewLabel) in [previewLabel1, previewLabel2, previewLabel3, previewLabel4].enumerated() {
            
            if currentCode.count > i {
                let index = currentCode.index(currentCode.startIndex, offsetBy: i)
                previewLabel.text = String(currentCode[index])
            }else{
                previewLabel.text = ""
            }
        }
        
        btnDelete.isHidden = currentCode.count == 0
    }
    
    func checkPINDisplay(){
        
        let rootVC: UIViewController = UIApplication.topViewController()!
        let savedPIN = UserDefaults.standard.string(forKey: "PIN")
        
        if rootVC.isKind(of: PINLockViewController.self) {
            print("pin already showing")
        }else if savedPIN != nil && savedPIN?.count == 4 {
            
            let lastEntryDate: Date? = UserDefaults.standard.object(forKey:"UNLOCK_DATE") as? Date ?? nil
            let lastExitDate: Date? = UserDefaults.standard.object(forKey:"EXIT_DATE") as? Date ?? nil
            
            if lastEntryDate != nil {
                let elapsed = Date().timeIntervalSince(lastEntryDate!)
                let duration = Int(elapsed)
                
                print ("Time elapsed since last PIN entry: \(duration)")
                if( duration < 5){
                    print("Hasn't been 5 seconds yet")
                    return
                }
            }
            
            if lastExitDate != nil {
                let elapsed = Date().timeIntervalSince(lastExitDate!)
                let duration = Int(elapsed)
                
                print ("Time elapsed since last exiting app: \(duration)")
                if( duration < 5){
                    print("Hasn't been 5 seconds yet")
                    return
                }
            }
            
            print("asking for auth PIN")
            self.currentAction = PINLockViewController.PIN_ACTION.AUTHENTICATION
            rootVC.present(self, animated: false, completion: nil)
        }else{
            print("No PIN setup")
        }
    }
    
    func resetPIN(){
        WalletManager.sharedInstance.deleteWallet()
        
        triesRemaining = 3
        UserDefaults.standard.set(triesRemaining, forKey: TRIES_REMAINING_KEY)
        UserDefaults.standard.synchronize()
        
        let rootVC: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
        
        if presentingViewController != nil {
            self.dismiss(animated: false, completion: {
                if rootVC.isKind(of: UINavigationController.self) {
                    let rootNC: UINavigationController = (UIApplication.shared.keyWindow?.rootViewController)! as! UINavigationController
                    rootNC.popToRootViewController(animated: true)
                }else{
                    rootVC.navigationController?.popToRootViewController(animated: true)
                }
            })
        }else{
            self.navigationController?.popViewController(animated: false)
            if rootVC.isKind(of: UINavigationController.self) {
                let rootNC: UINavigationController = (UIApplication.shared.keyWindow?.rootViewController)! as! UINavigationController
                rootNC.popToRootViewController(animated: true)
            }else{
                rootVC.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func setupTouchID() {
        
        print("Setting up touchID...")
        
        // Depending the iOS version we'll need to choose the policy we are able to use
        if #available(iOS 9.0, *) {
            // iOS 9+ users with Biometric and Passcode verification
            self.policy = .deviceOwnerAuthentication
        } else {
            // iOS 8+ users with Biometric and Custom (Fallback button) verification
            context.localizedFallbackTitle = "Wallet PIN"
            self.policy = .deviceOwnerAuthenticationWithBiometrics
        }
        
        var err: NSError?
        
        guard context.canEvaluatePolicy(self.policy!, error: &err) else {
            print ("touchID not available on this device")
            btnTouchID.isHidden = true
            return
        }
        
        if(currentAction == PIN_ACTION.AUTHENTICATION){
            btnTouchID.isHidden = false
        }
    }
    
    private func processTouchID() {
        // Start evaluation process with a callback that is executed when the user ends the process successfully or not
        context.evaluatePolicy(self.policy!, localizedReason: "Access Secured Waller", reply: { (success, error) in
            DispatchQueue.main.async {
                
                guard success else {
                    /*
                     guard let error = error else {
                     return
                     }
                     */
                    return
                }
                
                // Good news! Everything went fine 👏
                print("TOUCH ID SUCCESS!")
                self.PINSuccess()
            }
        })
    }
    
    private func PINSuccess(){
        print("PINSuccess")
        self.triesRemaining = 3
        UserDefaults.standard.set(self.triesRemaining, forKey: TRIES_REMAINING_KEY)
        UserDefaults.standard.set(Date(), forKey: "UNLOCK_DATE")
        if presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
