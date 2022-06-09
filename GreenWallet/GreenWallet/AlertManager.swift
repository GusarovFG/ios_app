//
//  AlertManager.swift
//  GreenWallet
//
//  Created by Фаддей Гусаров on 03.06.2022.
//

import UIKit

class AlertManager {
    
    
    static let share = AlertManager()
    
    private init(){}
    
    func seccessNewWallet(_ controller: UIViewController) {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AllertWalletViewController") as! AllertWalletViewController
        
        controller.present(alertVC, animated: true, completion: nil)
    }
    
    func errorNewWallet(_ controller: UIViewController) {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "DeleteContact") as! AllertWalletViewController
        alertVC.isNewWalletError = true
        
        
        controller.present(alertVC, animated: true, completion: nil)
    }
    
    func seccessSendToken(_ controller: UIViewController) {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let seccsessAlertVC = storyboard.instantiateViewController(withIdentifier: "seccsessTransitViewController") as! AllertWalletViewController
        controller.present(seccsessAlertVC, animated: true)
    }
    
    func errorSendToken(_ controller: UIViewController) {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let errorAlertVC = storyboard.instantiateViewController(withIdentifier: "DeleteContact") as! AllertWalletViewController
        errorAlertVC.isSendError = true
        controller.present(errorAlertVC, animated: true)
    }
    
    func seccessAddContect(_ controller: UIViewController) {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AddContactAlert") as! AllertWalletViewController
        controller.present(alertVC, animated: true)
    }
    
    func seccessEditContact(_ controller: UIViewController) {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AddContactAlert") as! AllertWalletViewController
        alertVC.isEditingContact = true
        alertVC.modalPresentationStyle = .fullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        controller.present(alertVC, animated: true)
    }
    
    func confirmDeleteContact(_ controller: UIViewController,_ indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Alert", bundle: .main)
        let alertVC = storyBoard.instantiateViewController(withIdentifier: "DeleteContact") as! AllertWalletViewController
        alertVC.index = indexPath.row
        alertVC.controller = controller
        
        controller.present(alertVC, animated: true)
    }
    
    
    
    func showSpinner(_ controller: UIViewController,_ isDeleting: Bool?) {
        let storyoard = UIStoryboard(name: "spinner", bundle: .main)
        let spinnerVC = storyoard.instantiateViewController(withIdentifier: "spinner") as! SprinnerViewController
        spinnerVC.isDeleting = isDeleting ?? false
        controller.present(spinnerVC, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            spinnerVC.dismiss(animated: true)
        }
    }

    func successDeletingContact(_ controller: UIViewController) {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AddContactAlert") as! AllertWalletViewController
        alertVC.isContact = true
        controller.present(alertVC, animated: true)
    }
    
    func successImportMnemonic(_ controller: UIViewController) {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alert = storyboard.instantiateViewController(withIdentifier: "AllertImportViewController") as! AllertWalletViewController
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    func seccessAskAQuestion(_ controller: UIViewController) {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alert = storyboard.instantiateViewController(withIdentifier: "seccsessTransitViewController") as! AllertWalletViewController
        alert.isAskAQuestion = true
        
        controller.present(alert, animated: true)
    
    }
}