//
//  CryptoCoinsEndpoint+Extension.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 17/12/24.
//

import Foundation
@testable import SiddharthSuneel_Task

protocol TestableRequest {
    var localJSONFileName: String { get }
}

extension CryptoCoinsEndpoint: TestableRequest {
    var localJSONFileName: String {
        "CryptoCoinListResponse"
    }
}
