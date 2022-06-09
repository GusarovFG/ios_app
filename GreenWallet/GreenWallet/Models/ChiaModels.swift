//
//  ChiaModels.swift
//  GreenWallet
//
//  Created by Фаддей Гусаров on 09.06.2022.
//

import Foundation

struct ChiaGeneratingMnemonic: Codable {
    let mnemonic: [String]
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case mnemonic
        case success
    }
}

struct ChiaFingerPrint: Codable {
    let fingerprint: Int
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case fingerprint
        case success
    }
}

struct ChiaImportMnemonic: Codable {
    var mnemonic: [String]
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case mnemonic
        case type
    }
}

struct ChiaPrivate: Codable {
    let private_key: ChiaPrivateKey
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case private_key
        case success
    }
}

struct ChiaPrivateKey: Codable {
    let farmer_pk: String
    let fingerprint: Int
    let pk: String
    let pool_pk: String
    let seed: String
    let sk: String

    enum CodingKeys: String, CodingKey {
        case farmer_pk
        case fingerprint
        case pk
        case pool_pk
        case seed
        case sk
    }
}

struct ChiaWallets: Codable {
    let success: Bool
    let wallets: [ChiaWallet]

    enum CodingKeys: String, CodingKey {
        case success
        case wallets
    }
}

// MARK: - Wallet
struct ChiaWallet: Codable {
    let data: String
    let id: Int
    let name: String
    let type: Int

    enum CodingKeys: String, CodingKey {
        case data
        case id
        case name
        case type
    }
}

struct ChiaWalletBalance: Codable {
    let success: Bool
    let wallet_balance: WalletBalance

    enum CodingKeys: String, CodingKey {
        case success
        case wallet_balance
    }
}

// MARK: - WalletBalance
struct WalletBalance: Codable {
    let confirmed_wallet_balance: Int
    let fingerprint: Int
    let max_send_amount: Int
    let pending_change: Int
    let pending_coin_removal_count: Int
    let spendable_balance: Int
    let unconfirmed_wallet_balance: Int
    let unspent_coin_count: Int
    let wallet_id: Int

    enum CodingKeys: String, CodingKey {
        case confirmed_wallet_balance
        case fingerprint
        case max_send_amount
        case pending_change
        case pending_coin_removal_count
        case spendable_balance
        case unconfirmed_wallet_balance
        case unspent_coin_count
        case wallet_id
    }
}

struct LogIn: Codable {
    
    var fingerprint: Int
    var success: Bool
    
    enum CodingKeys: String, CodingKey {
        case fingerprint
        case success
      
    }

}

