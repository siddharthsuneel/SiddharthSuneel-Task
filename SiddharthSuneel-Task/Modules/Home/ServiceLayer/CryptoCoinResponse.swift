//
//  CryptoCoinResponse.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 20/12/24.
//

import Foundation

struct CryptoCoinResponse: Decodable {
    let name: String?
    let symbol: String?
    let isNew: Bool?
    let isActive: Bool?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }
}
