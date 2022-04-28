//
//  MainViewController.swift
//  GreenWallet
//
//  Created by Фаддей Гусаров on 26.04.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private var balance = 0
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var riseLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var walletsTableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if UserDefaultsManager.shared.userDefaults.bool(forKey: UserDefaultsStringKeys.hideWalletsBalance.rawValue) {
            self.balanceLabel.text = "***** USD"
        } else {
            self.balanceLabel.text = "\(self.balance) USD"
        }
        
        self.walletsTableView.register(UINib(nibName: "BalanceTableViewCell", bundle: nil), forCellReuseIdentifier: "walletCell")
        self.walletsTableView.register(UINib(nibName: "ImportTableViewCell", bundle: nil), forCellReuseIdentifier: "importCell")
        //        self.stackView.removeArrangedSubview(self.walletsTableView)
        
        self.headerView.layer.cornerRadius = 15
        self.headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.footerView.layer.cornerRadius = 15
        self.footerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let navigationItem = UINavigationItem()
        let settingsItem = UIBarButtonItem(image: UIImage(named: "Menu")!, style: .done, target: self, action: #selector(pushSettingsController))
        settingsItem.tintColor = .white
        navigationItem.rightBarButtonItem = settingsItem
        self.navigationController?.navigationBar.setItems([navigationItem], animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideWallet), name: NSNotification.Name(rawValue: "hideWallet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showWallet), name: NSNotification.Name(rawValue: "showWallet"), object: nil)
        
    }
    
    private func presentSelectSystemVC() {
        
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "SelectSystemViewController") as! SelectSystemViewController
        let nav = UINavigationController(rootViewController: detailViewController)
        
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func pushSettingsController() {
        
        let settingsViewController = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let nav = UINavigationController(rootViewController: settingsViewController)
        nav.navigationBar.isHidden = true
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func hideWallet(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let text = userInfo[""] as? String else { return }
        self.balanceLabel.text = text
        
    }
    
    @objc private func showWallet(notification: Notification) {
        self.balanceLabel.text = "\(self.balance) USD"
        
    }
    
    @IBAction func addWalletButtonPressed(_ sender: Any) {
        presentSelectSystemVC()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let importCell = tableView.dequeueReusableCell(withIdentifier: "importCell", for: indexPath) as! ImportTableViewCell
        let walletCell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath) as! BalanceTableViewCell
        switch indexPath {
        case [0,2]:
            return importCell
        default:
            return walletCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,2]:
            let importTokensVC = storyboard?.instantiateViewController(withIdentifier: "ImportTokensViewController") as! ImportTokensViewController
            importTokensVC.modalPresentationStyle = .fullScreen
            self.navigationController!.present(importTokensVC, animated: true, completion: nil)
        default:
            break
        }
    }
}