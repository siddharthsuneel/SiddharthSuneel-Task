//
//  CryptoCoinsEndpoint.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 16/12/24.
//

import Foundation

class CryptoCoinsEndpoint: BaseEndpoint {
    init() {
        super.init(path: "/", method: .get)
    }
}
