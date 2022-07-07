//
//  MainTabBarController.swift
//  GreenWallet
//
//  Created by Фаддей Гусаров on 03.05.2022.
//

import UIKit

class MainTabBarController: UITabBarController, UINavigationBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        addTabs()
        self.tabBar.tintColor = #colorLiteral(red: 0.2274509804, green: 0.6745098039, blue: 0.3490196078, alpha: 1)
        
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(changeIndex), name: NSNotification.Name("ChangeIndex"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadInputViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc private func changeIndex() {
        self.selectedIndex = 0
    }
    
    private func addTabs() {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "navi") as! UINavigationController
        mainVC.tabBarItem = UITabBarItem(title: LocalizationManager.share.translate?.result.list.main_screen.main_screen_title_purse, image: UIImage(named: "wallet")!, selectedImage: UIImage(named: "wallet")!)
        
        let secondMainVC = storyboard?.instantiateViewController(withIdentifier: "navi") as! UINavigationController
        secondMainVC.tabBarItem = UITabBarItem(title: LocalizationManager.share.translate?.result.list.main_screen.main_screen_recive_btn, image: UIImage(named: "get")!, selectedImage: UIImage(named: "get")!)
        
        let thirdMainVC = storyboard?.instantiateViewController(withIdentifier: "navi") as! UINavigationController
        thirdMainVC.tabBarItem = UITabBarItem(title: LocalizationManager.share.translate?.result.list.main_screen.main_screen_send_btn, image: UIImage(named: "push")!, selectedImage: UIImage(named: "push")!)
        
        let fourMainVC = storyboard?.instantiateViewController(withIdentifier: "TransactionHistoryVC") as! TransactionHistoryViewController
        fourMainVC.modalPresentationStyle = .fullScreen
        fourMainVC.tabBarItem = UITabBarItem(title: LocalizationManager.share.translate?.result.list.main_screen.main_screen_transaction_btn, image: UIImage(named: "transaction")!, selectedImage: UIImage(named: "transaction")!)
        
        let fiveMainVC = storyboard?.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
        fiveMainVC.modalPresentationStyle = .fullScreen
        fiveMainVC.tabBarItem = UITabBarItem(title: LocalizationManager.share.translate?.result.list.main_screen.main_screen_addresses_btn, image: UIImage(named: "adress")!, selectedImage: UIImage(named: "adress")!)

        self.setViewControllers([mainVC, secondMainVC, thirdMainVC, fourMainVC, fiveMainVC], animated: true)
        self.navigationController?.navigationBar.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if tabBar.selectedItem?.title == LocalizationManager.share.translate?.result.list.main_screen.main_screen_recive_btn {
                    let selectSystemVC = storyboard?.instantiateViewController(withIdentifier: "SelectSystemViewController") as! SelectSystemViewController
                    selectSystemVC.isGetToken = true
                    selectSystemVC.modalPresentationStyle = .overFullScreen
                    self.present(selectSystemVC, animated: true)
                
            
        }
        
        if tabBar.selectedItem?.title == LocalizationManager.share.translate?.result.list.main_screen.main_screen_send_btn {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showPushVC"), object: nil)
        }
        

    }
    
    
}

extension MainTabBarController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}
