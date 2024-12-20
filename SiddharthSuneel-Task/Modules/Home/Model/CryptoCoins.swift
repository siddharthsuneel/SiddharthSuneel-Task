//
//  CryptoCoins.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 17/12/24.
//

import Foundation

protocol CryptoCoinProtocol {
    var name: String? { get }
    var symbol: String? { get }
    var isNew: Bool? { get }
    var isActive: Bool? { get }
    var type: CryptoType { get }
    var iconName: String { get }
}

struct CryptoCoin: CryptoCoinProtocol {
    init(
        name: String? = nil,
        symbol: String? = nil,
        isNew: Bool? = nil,
        isActive: Bool? = nil,
        type: String) {
        self.name = name
        self.symbol = symbol
        self.isNew = isNew
        self.isActive = isActive
        self.type = CryptoType.init(rawValue: type) ?? .unknown
    }
    
    let name: String?
    let symbol: String?
    let isNew: Bool?
    let isActive: Bool?
    let type: CryptoType

    var iconName: String {
        switch type {
        case .coin:
            return (isActive ?? false) ? "cyptoCoinActive" : "cyptoCoinInActive"
        case .token:
            return "cyptoTokenActive"
        case .unknown:
            return "unknown"
        }
    }
}

enum CryptoType: String, Decodable {
    case coin
    case token
    case unknown
}
