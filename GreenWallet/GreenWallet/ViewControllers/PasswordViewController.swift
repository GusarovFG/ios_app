//
//  PasswordViewController.swift
//  GreenWallet
//
//  Created by Фаддей Гусаров on 14.05.2022.
//

import UIKit
import AVFAudio
import LocalAuthentication
import AVFoundation

class PasswordViewController: UIViewController {
    
    var index = 0
    var isShowDetail = false
    var isMyWallet = false
    var isDeleteWallet = false
    var isAllWallets = false
    var isPushToken = false
    
    private var isFirstSession = false
    private var enteringPassword = ""
    private var repitingPassword = ""
    private var finalPassword = ""
    private var userInfo = ["seccsess": 0]
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dotsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dotsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var faceIDButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var discriptionTitle: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var createTitleLabel: UILabel!
    @IBOutlet weak var createDiscriptionTitle: UILabel!
    @IBOutlet weak var createErrorLabel: UILabel!
    
    @IBOutlet weak var repeatTitleLabel: UILabel!
    @IBOutlet weak var repeatDiscriptionTitle: UILabel!
    @IBOutlet weak var repeatErrorLabel: UILabel!
    
    @IBOutlet weak var enterTitleLabel: UILabel!
    @IBOutlet weak var enterErrorLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var firstDigitsStackView: UIStackView!
    @IBOutlet weak var secondDigitsStackView: UIStackView!
    @IBOutlet weak var thirdDigitsStackView: UIStackView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        NotificationCenter.default.addObserver(self, selector: #selector(deleteInMyWallet), name: NSNotification.Name("deleteInMyWallet"), object: nil)
        
        print(self.isMyWallet)
        if self.isShowDetail {
            self.faceIDButton.isEnabled = false
            self.faceIDButton.alpha = 0
        }
        
        self.stackView.arrangedSubviews.forEach { view in
            view.layer.cornerRadius = view.frame.height / 2
            view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
            view.layer.borderWidth = 2
            if UserDefaultsManager.shared.userDefaults.string(forKey: "Theme") == "dark" {
                view.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                view.layer.borderColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
            }
        }
        if self.isPushToken {
            WalletManager.share.isUpdate = false

        }
        
        if UIDevice.modelName.contains("iPhone 8") || UIDevice.modelName.contains("iPhone 12") || UIDevice.modelName.contains("iPhone 13") {
            self.firstDigitsStackView.spacing = 15
            self.secondDigitsStackView.spacing = 15
            self.thirdDigitsStackView.spacing = 15
            self.stackView.spacing = 20
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func localization() {
       
        if self.restorationIdentifier == "CreatingPasswordViewController" {
            self.createTitleLabel.text = LocalizationManager.share.translate?.result.list.create_a_passcode.creating_a_password_titel
            self.createDiscriptionTitle.text = LocalizationManager.share.translate?.result.list.create_a_passcode.creating_a_password_description
            self.createErrorLabel.text = LocalizationManager.share.translate?.result.list.create_a_passcode.creating_a_password_error_amount_of_characters
            self.backButton.setTitle(LocalizationManager.share.translate?.result.list.all.back_btn, for: .normal)
        } else if self.restorationIdentifier == "RepeatingPasswordViewController" {
            self.repeatTitleLabel.text = LocalizationManager.share.translate?.result.list.create_a_passcode.repeat_passcode_title
            self.repeatDiscriptionTitle.text = LocalizationManager.share.translate?.result.list.create_a_passcode.repeat_passcode_description
            self.repeatErrorLabel.text = LocalizationManager.share.translate?.result.list.create_a_passcode.creating_a_password_error_difference
            self.backButton.setTitle(LocalizationManager.share.translate?.result.list.all.back_btn, for: .normal)
        } else if self.restorationIdentifier == "EnteringPasswordViewController" {
            self.enterTitleLabel.text = LocalizationManager.share.translate?.result.list.all.passcode_confirmation_title
            self.enterErrorLabel.text = LocalizationManager.share.translate?.result.list.passcode_entry_screen.passcode_entry_screen_error
            self.resetButton.setTitle(LocalizationManager.share.translate?.result.list.passcode_entry_screen.passcode_entry_screen_reset, for: .normal)
//            self.backButton.setTitle(LocalizationManager.share.translate?.result.list.all.back_btn, for: .normal)
            
        } else {
            self.mainTitle.text = LocalizationManager.share.translate?.result.list.all.passcode_confirmation_title
            self.discriptionTitle.text = LocalizationManager.share.translate?.result.list.all.passcode_confirmation_description
            self.errorLabel.text = LocalizationManager.share.translate?.result.list.passcode_entry_screen.passcode_entry_screen_error
            self.mainButton.setTitle(LocalizationManager.share.translate?.result.list.all.return_btn, for: .normal)
//            self.backButton.setTitle(LocalizationManager.share.translate?.result.list.all.back_btn, for: .normal)
        }
    }
    

    @objc func deleteInMyWallet() {
        self.isMyWallet = true
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func enterIngDigit(_ sender: UIButton) {
        
        if self.enteringPassword.count < 6  {
            self.enteringPassword += (sender.titleLabel?.text)!
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].backgroundColor = #colorLiteral(red: 0.2681596875, green: 0.717217505, blue: 0.4235975146, alpha: 1)
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].layer.borderWidth = 0

        }

        if self.enteringPassword == KeyChainManager.share.loadPassword()  {
            self.dismiss(animated: true)
            if !self.isShowDetail && !self.isMyWallet && !self.isPushToken {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeAlert"), object: nil)
            }

            if self.isShowDetail && !self.isMyWallet {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showDetail"), object: nil)
            }
            if self.isMyWallet && !self.isShowDetail {
                CoreDataManager.share.deleteChiaWalletPrivateKey(index: self.index)

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteWallet"), object: nil)
            }
            if self.isPushToken {
                NotificationCenter.default.post(name: NSNotification.Name("pushToken"), object: nil)
            }
            
            if self.isAllWallets {
                WalletManager.share.favoritesWallets.removeAll(where: {$0 == CoreDataManager.share.fetchChiaWalletPrivateKey()[self.index]})
                CoreDataManager.share.deleteChiaWalletPrivateKey(index: self.index)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteWalletAtIntex"), object: nil)

            }
        } else if self.enteringPassword.count == 6 && self.enteringPassword != KeyChainManager.share.loadPassword() {
            self.stackView.arrangedSubviews.forEach { view in
                view.layer.cornerRadius = view.frame.height / 2
                view.backgroundColor = #colorLiteral(red: 1, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
                view.layer.borderWidth = 0
                view.layer.borderColor = #colorLiteral(red: 1, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
                self.errorLabel.alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.stackView.arrangedSubviews.forEach { view in
                        view.layer.cornerRadius = view.frame.height / 2
                        view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
                        view.layer.borderWidth = 2
                        if UserDefaultsManager.shared.userDefaults.string(forKey: "Theme") == "dark" {
                            view.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        } else {
                            view.layer.borderColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
                        }
                        self.enteringPassword = ""
                        self.errorLabel.alpha = 0
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func deleteLastDigit(_ sender: Any) {
        if self.enteringPassword.count > 0 {
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].layer.borderWidth = 2
            
            
            if UserDefaultsManager.shared.userDefaults.string(forKey: "Theme") == "dark" {
                self.stackView.arrangedSubviews[self.enteringPassword.count - 1].layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                self.stackView.arrangedSubviews[self.enteringPassword.count - 1].layer.borderColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
            }
            self.enteringPassword.removeLast()
        
        }
    }
    
    @IBAction func faceIDButtonPressed(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async { [unowned self] in
                    if success {
                        if self!.isFirstSession {
                            let storyboard = UIStoryboard(name: "Main", bundle: .main)
                            let startVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                            self!.view.window?.rootViewController = startVC
                        } else {
                            self?.dismiss(animated: true)
                            if !self!.isShowDetail {
                                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                                let greatingVC = storyboard.instantiateViewController(withIdentifier: "GreatingViewController") as! GreatingViewController
                                greatingVC.modalPresentationStyle = .fullScreen
                                greatingVC.modalTransitionStyle = .crossDissolve

                                self?.present(greatingVC, animated: true)
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Seccess"), object: nil, userInfo: self?.userInfo)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeAlert"), object: nil)
                                if self!.isAllWallets {
                                    CoreDataManager.share.deleteChiaWalletPrivateKey(index: self!.index)

                                    NotificationCenter.default.post(name: NSNotification.Name("deleteWalletAtIntex"), object: nil)
                                }
                                
                                if self!.isMyWallet {
                                    CoreDataManager.share.deleteChiaWalletPrivateKey(index: self!.index)

                                    NotificationCenter.default.post(name: NSNotification.Name("deleteWallet"), object: nil)
                                }
                                
                                if self!.isPushToken {
                                    NotificationCenter.default.post(name: NSNotification.Name("pushToken"), object: nil)
                                }
                            }
                        }
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    @IBAction func reloadAppButtonPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Alert", bundle: .main)
        let alertVC = storyBoard.instantiateViewController(withIdentifier: "DeleteWallet") as! AllertWalletViewController
        alertVC.controller = self
        alertVC.isReloadAll = true
        
        self.present(alertVC, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func creatingPassword(_ sender: UIButton) {
        if self.enteringPassword.count < 6 {
            self.enteringPassword += sender.titleLabel?.text ?? ""
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].backgroundColor = #colorLiteral(red: 0.2681596875, green: 0.717217505, blue: 0.4235975146, alpha: 1)
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].layer.borderWidth = 0
        }
        
        if self.enteringPassword.count == 6 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let passwordStoryboard = UIStoryboard(name: "PasswordStoryboard", bundle: .main)
                let repeatingPasswordVC = passwordStoryboard.instantiateViewController(withIdentifier: "RepeatingPasswordViewController") as! PasswordViewController
                repeatingPasswordVC.modalPresentationStyle = .fullScreen
                repeatingPasswordVC.repitingPassword = self.enteringPassword
                self.present(repeatingPasswordVC, animated: true)
                
            }
        }
    }
    
    @IBAction func repeatingPassword(_ sender: UIButton) {
        

        
        if self.enteringPassword.count < 6 {
            self.enteringPassword += sender.titleLabel?.text ?? ""
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].backgroundColor = #colorLiteral(red: 0.2681596875, green: 0.717217505, blue: 0.4235975146, alpha: 1)
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].layer.borderWidth = 0
        } else if self.enteringPassword.count == 6 && self.enteringPassword != self.repitingPassword {
            self.stackView.arrangedSubviews.forEach { view in
                view.layer.cornerRadius = view.frame.height / 2
                view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
                view.layer.borderWidth = 2
                if UserDefaultsManager.shared.userDefaults.string(forKey: "Theme") == "dark" {
                    view.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    view.layer.borderColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
                }
                self.repeatErrorLabel.alpha = 0
            }
            self.enteringPassword = ""
            self.enteringPassword += sender.titleLabel?.text ?? ""
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].backgroundColor = #colorLiteral(red: 0.2681596875, green: 0.717217505, blue: 0.4235975146, alpha: 1)
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].layer.borderWidth = 0
        }
        
        if self.enteringPassword == self.repitingPassword {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let passwordStoryboard = UIStoryboard(name: "PasswordStoryboard", bundle: .main)
                let enterPasswordVC = passwordStoryboard.instantiateViewController(withIdentifier: "EnteringPasswordViewController") as! PasswordViewController
                enterPasswordVC.modalPresentationStyle = .fullScreen
                enterPasswordVC.isFirstSession = true
                enterPasswordVC.finalPassword = self.enteringPassword
                Password.sahre.password = self.enteringPassword
                KeyChainManager.share.savePassword(self.enteringPassword)
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                let greatingVC = storyboard.instantiateViewController(withIdentifier: "GreatingViewController") as! GreatingViewController
                greatingVC.modalPresentationStyle = .fullScreen
                greatingVC.modalTransitionStyle = .crossDissolve

                self.present(greatingVC, animated: true)
                
            }
        } else if self.enteringPassword.count == 6 && self.enteringPassword != self.repitingPassword{
            self.stackView.arrangedSubviews.forEach { view in
                view.layer.cornerRadius = view.frame.height / 2
                view.backgroundColor = #colorLiteral(red: 1, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
                view.layer.borderWidth = 0
                view.layer.borderColor = #colorLiteral(red: 1, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
                self.repeatErrorLabel.alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.stackView.arrangedSubviews.forEach { view in
                        view.layer.cornerRadius = view.frame.height / 2
                        view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
                        view.layer.borderWidth = 2
                        if UserDefaultsManager.shared.userDefaults.string(forKey: "Theme") == "dark" {
                            view.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        } else {
                            view.layer.borderColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
                        }
                        self.repeatErrorLabel.alpha = 0
                    }
                    self.enteringPassword = ""
                }
            }
        }
        

    }
    
    @IBAction func enterPassword(_ sender: UIButton) {
        if self.enteringPassword.count < 6 {
            self.enteringPassword += sender.titleLabel?.text ?? ""
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].backgroundColor = #colorLiteral(red: 0.2681596875, green: 0.717217505, blue: 0.4235975146, alpha: 1)
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].layer.borderWidth = 0
        } else if self.enteringPassword.count == 6 && self.enteringPassword != KeyChainManager.share.loadPassword() {
            self.stackView.arrangedSubviews.forEach { view in
                view.layer.cornerRadius = view.frame.height / 2
                view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
                view.layer.borderWidth = 2
                if UserDefaultsManager.shared.userDefaults.string(forKey: "Theme") == "dark" {
                    view.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    view.layer.borderColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
                }
                self.enterErrorLabel.alpha = 0
            }
            self.enteringPassword = ""
            self.enteringPassword += sender.titleLabel?.text ?? ""
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].backgroundColor = #colorLiteral(red: 0.2681596875, green: 0.717217505, blue: 0.4235975146, alpha: 1)
            self.stackView.arrangedSubviews[self.enteringPassword.count - 1].layer.borderWidth = 0
        }
        
        if self.enteringPassword == KeyChainManager.share.loadPassword() {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let greatingVC = storyboard.instantiateViewController(withIdentifier: "GreatingViewController") as! GreatingViewController
            greatingVC.modalPresentationStyle = .fullScreen
            greatingVC.modalTransitionStyle = .crossDissolve

            self.present(greatingVC, animated: true)
            
            
            

        } else if self.enteringPassword.count == 6 && self.enteringPassword != KeyChainManager.share.loadPassword() {
            self.stackView.arrangedSubviews.forEach { view in
                view.layer.cornerRadius = view.frame.height / 2
                view.backgroundColor = #colorLiteral(red: 1, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
                view.layer.borderWidth = 0
                view.layer.borderColor = #colorLiteral(red: 1, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
                self.enterErrorLabel.alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.stackView.arrangedSubviews.forEach { view in
                        view.layer.cornerRadius = view.frame.height / 2
                        view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
                        view.layer.borderWidth = 2
                        if UserDefaultsManager.shared.userDefaults.string(forKey: "Theme") == "dark" {
                            view.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        } else {
                            view.layer.borderColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
                        }
                        self.enterErrorLabel.alpha = 0
                    }
                    self.enteringPassword = ""
                }
            }
        }
    }
    

}
