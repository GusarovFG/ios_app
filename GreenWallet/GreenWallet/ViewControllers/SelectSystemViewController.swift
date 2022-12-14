//
//  SelectSystemView.swift
//  GreenWallet
//
//  Created by Фаддей Гусаров on 27.04.2022.
//

import UIKit

class SelectSystemViewController: UIViewController {
    
    
    private var allSystems = Systems(success: false, result: ResultSystems(version: "", list: [ListSystems(name: "", full_node: "", wallet: "", daemon: "", farmer: "", harvester: "")]))
    private var filterSystems: [ListSystems] = []
    
    private var typseOfNewWallet: [String] = [LocalizationManager.share.translate?.result.list.all.add_wallet_new ?? "", LocalizationManager.share.translate?.result.list.all.add_wallet_import ?? ""]
    var isSelectedSystem = false
    var isGetToken = false
    var isPushToken = false
    var isNewWallet = false
    var isChia = false
    var isChives = false
    var isChiaTest = false
    var isChivesTest = false
    var isMainScreen = false
    var isInMyWallet = false
    var wallet: ChiaWalletPrivateKey?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allSystems = SystemsManager.share.systems
        if self.isNewWallet {
            self.filterSystems = self.allSystems.result.list
        } else if self.isPushToken || self.isGetToken{
            SystemsManager.share.filterSystems()
            self.filterSystems = SystemsManager.share.listOfSystems
            self.filterSystems = Array(Set(SystemsManager.share.listOfSystems))
            
        }
        
        self.view.window?.frame.size = CGSize(width: 414, height: 238)
        self.tableView.register(UINib(nibName: "SelectSystemTableViewCell", bundle: nil), forCellReuseIdentifier: "systemCell")
        self.navigationController?.navigationBar.isHidden = true
        self.headerView.layer.cornerRadius = 15
        self.headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        localization()
        //        if self.isNewWallet {
        //            self.titleLabel.text = LocalizationManager.share.translate?.result.list.all.add_wallet_title
        //        }
        let swipeGasture = UISwipeGestureRecognizer(target: self, action: #selector(dismissSwipe))
        swipeGasture.direction = .down
        
        let tapGasture = UITapGestureRecognizer(target: self, action: #selector(dismissSwipe))
        tapGasture.delegate = self
        self.view.addGestureRecognizer(tapGasture)
        self.view.addGestureRecognizer(swipeGasture)
        NotificationCenter.default.addObserver(self, selector: #selector(localization), name: NSNotification.Name("localized"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !self.isSelectedSystem {
            self.heightConstraint.constant = CGFloat((self.filterSystems.count * 74)) + 30
            
        } else {
            self.heightConstraint.constant = (2 * 74) + 30
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3481637311)
        }
        print(self.filterSystems)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("ChangeIndex"), object: nil)
        
    }
    
    
    @objc private func localization() {
        if !CoreDataManager.share.fetchChiaWalletPrivateKey().isEmpty {
            self.titleLabel.text = LocalizationManager.share.translate?.result.list.all.select_network

        } else {
            
            self.titleLabel.text = LocalizationManager.share.translate?.result.list.all.select_network_new_wallet
        }
    }
    
    @objc func dismissSwipe() {
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
        self.dismiss(animated: true)
    }
    
}

extension SelectSystemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSelectedSystem {
            return 2
        } else {
            if self.isChia && self.isPushToken && !self.isMainScreen {
                self.filterSystems = self.allSystems.result.list.filter({$0.name.contains("Chia")})
                return self.filterSystems.count
            } else if !self.isChia && self.isPushToken && !self.isMainScreen {
                self.filterSystems = self.allSystems.result.list.filter({$0.name.contains("Chives")})
                return self.filterSystems.count
            } else if self.isChia && self.isPushToken && self.isMainScreen {
                return self.filterSystems.count
            } else {
                return self.filterSystems.count
                
                
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedSystemCell = tableView.dequeueReusableCell(withIdentifier: "systemCell", for: indexPath) as! SelectSystemTableViewCell
        let selectTypeOfWalletCell = tableView.dequeueReusableCell(withIdentifier: "typeOfWalletCell", for: indexPath)
        
        switch self.isSelectedSystem {
        case false:
            selectedSystemCell.nameOfSystemLabel.text = self.filterSystems[indexPath.row].name
            if selectedSystemCell.nameOfSystemLabel.text == "Chia Network" || selectedSystemCell.nameOfSystemLabel.text == "Chia TestNet" {
                selectedSystemCell.tokensLabel.text = "XCH"
                selectedSystemCell.systemImage.image = UIImage(named: "LogoChia")!
            } else {
                selectedSystemCell.tokensLabel.text = "XCC"
                selectedSystemCell.systemImage.image = UIImage(named: "ChivesLogo")!
            }
            
            
            return selectedSystemCell
        case true:
            selectTypeOfWalletCell.accessoryType = .disclosureIndicator
            var content = selectTypeOfWalletCell.defaultContentConfiguration()
            content.text = self.typseOfNewWallet[indexPath.row]
            selectTypeOfWalletCell.contentConfiguration = content
            return selectTypeOfWalletCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if self.isSelectedSystem && !self.isGetToken && !self.isPushToken {
            switch indexPath {
            case [0,0]:
                let newWalletVC = storyboard?.instantiateViewController(withIdentifier: "NewWalletViewController") as! NewWalletViewController
                newWalletVC.isChia = self.isChia
                newWalletVC.isChiaTest = self.isChiaTest
                newWalletVC.isChives = self.isChives
                newWalletVC.isChivesTest = self.isChivesTest
                self.present(newWalletVC, animated: true, completion: nil)
            case [0,1]:
                let newWalletVC = storyboard?.instantiateViewController(withIdentifier: "ImportMnemonicViewController") as! ImportMnemonicViewController
                newWalletVC.isChia = self.isChia
                newWalletVC.isChiaTest = self.isChiaTest
                newWalletVC.isChives = self.isChives
                newWalletVC.isChivesTest = self.isChivesTest
                
                self.present(newWalletVC, animated: true, completion: nil)
            default:
                break
            }
        } else if !self.isSelectedSystem && self.isGetToken && !self.isPushToken  {
            let cell = self.tableView.cellForRow(at: indexPath) as! SelectSystemTableViewCell
            switch cell.nameOfSystemLabel.text  {
            case "Chia Network":
                let gettVC = storyboard?.instantiateViewController(withIdentifier: "GetTokenViewController") as! GetTokenViewController
                gettVC.modalPresentationStyle = .fullScreen
                gettVC.isChia = true
                self.present(gettVC, animated: true, completion: nil)
            case "Chia TestNet":
                let gettVC = storyboard?.instantiateViewController(withIdentifier: "GetTokenViewController") as! GetTokenViewController
                gettVC.modalPresentationStyle = .fullScreen
                gettVC.isChiaTest = true
                self.present(gettVC, animated: true, completion: nil)
            case "Chives Network":
                let gettVC = storyboard?.instantiateViewController(withIdentifier: "GetTokenViewController") as! GetTokenViewController
                gettVC.modalPresentationStyle = .fullScreen
                gettVC.isChives = true
                self.present(gettVC, animated: true, completion: nil)
            case "Chives TestNet":
                let gettVC = storyboard?.instantiateViewController(withIdentifier: "GetTokenViewController") as! GetTokenViewController
                gettVC.modalPresentationStyle = .fullScreen
                gettVC.isChivesTest = true
                self.present(gettVC, animated: true, completion: nil)
            default:
                break
            }
        } else if !self.isSelectedSystem && !self.isGetToken && self.isPushToken  {
            let cell = self.tableView.cellForRow(at: indexPath) as! SelectSystemTableViewCell
            switch cell.nameOfSystemLabel.text  {
            case "Chia Network":
                let gettVC = storyboard?.instantiateViewController(withIdentifier: "PushTokensViewController") as! PushTokensViewController
                gettVC.modalPresentationStyle = .fullScreen
                gettVC.isChia = true
                if self.isInMyWallet {
                    gettVC.wallet = self.wallet
                    gettVC.isInMyWallet = true
                }
                self.present(gettVC, animated: true, completion: nil)
            case "Chia TestNet":
                let gettVC = storyboard?.instantiateViewController(withIdentifier: "PushTokensViewController") as! PushTokensViewController
                gettVC.modalPresentationStyle = .fullScreen
                gettVC.isChiaTest = true
                if self.isInMyWallet {
                    gettVC.wallet = self.wallet
                    gettVC.isInMyWallet = true
                }
                self.present(gettVC, animated: true, completion: nil)
            case "Chives Network":
                let gettVC = storyboard?.instantiateViewController(withIdentifier: "PushTokensViewController") as! PushTokensViewController
                gettVC.modalPresentationStyle = .fullScreen
                gettVC.isChives = true
                if self.isInMyWallet {
                    gettVC.wallet = self.wallet
                    gettVC.isInMyWallet = true
                }
                self.present(gettVC, animated: true, completion: nil)
            case "Chives TestNet":
                let gettVC = storyboard?.instantiateViewController(withIdentifier: "PushTokensViewController") as! PushTokensViewController
                gettVC.modalPresentationStyle = .fullScreen
                gettVC.isChivesTest = true
                if self.isInMyWallet {
                    gettVC.wallet = self.wallet
                    gettVC.isInMyWallet = true
                }
                self.present(gettVC, animated: true, completion: nil)
            default:
                break
            }
        } else if !self.isSelectedSystem && !self.isGetToken && !self.isPushToken  {
            switch indexPath  {
            case [0,0]:
                self.isChia = true
                self.isSelectedSystem = true
                self.titleLabel.text = LocalizationManager.share.translate?.result.list.all.add_wallet_title
                self.tableView.reloadData()
            case [0,1]:
                self.isChiaTest = true
                self.isSelectedSystem = true
                self.titleLabel.text = LocalizationManager.share.translate?.result.list.all.add_wallet_title
                self.tableView.reloadData()
            case [0,2]:
                self.isChives = true
                self.isSelectedSystem = true
                self.titleLabel.text = LocalizationManager.share.translate?.result.list.all.add_wallet_title
                self.tableView.reloadData()
            case [0,3]:
                self.isChivesTest = true
                self.isSelectedSystem = true
                self.titleLabel.text = LocalizationManager.share.translate?.result.list.all.add_wallet_title
                self.tableView.reloadData()
            default:
                break
            }
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SelectSystemViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableView) == true || touch.view?.isDescendant(of: self.headerView) == true {
            return false
        } else {
            return true
        }
    }
}
