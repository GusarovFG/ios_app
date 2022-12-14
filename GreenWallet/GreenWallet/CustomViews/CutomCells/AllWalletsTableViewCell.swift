//
//  AllWalletsTableViewCell.swift
//  GreenWallet
//
//  Created by Фаддей Гусаров on 18.05.2022.
//

import UIKit

class AllWalletsTableViewCell: UITableViewCell {
    
 
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(wallet: ChiaWalletPrivateKey) {
        if wallet.name == "Chia Wallet" || wallet.name == "Chia TestNet" {
            self.cellImage.image = UIImage(named: "LogoChia")!
            self.tokenLabel.text = "XCH"
            
        } else if wallet.name == "Chives Wallet" || wallet.name == "Chives TestNet" {
            self.cellImage.image = UIImage(named: "ChivesLogo")!
            self.tokenLabel.text = "XCC"
        }
        self.walletLabel.text = wallet.name
        self.keyLabel.text = "\(String(describing: LocalizationManager.share.translate?.result.list.wallet.wallet_data_public_key ?? "")) \(wallet.fingerprint)"
        
    }
    
}
