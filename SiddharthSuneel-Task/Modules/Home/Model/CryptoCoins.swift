//
//  CryptoCoins.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 17/12/24.
//

import Foundation

struct CryptoCoins: Decodable {
    let name: String?
    let symbol: String?
    let isNew: Bool?
    let isActive: Bool?
    let type: CryptoType?

    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }
}

enum CryptoType: String, Decodable {
    case coin
    case token
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = CryptoType(rawValue: rawValue) ?? .unknown
    }
}