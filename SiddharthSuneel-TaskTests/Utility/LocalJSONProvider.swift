//
//  Untitled.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 17/12/24.
//

import Foundation
@testable import SiddharthSuneel_Task

protocol LocalJSONProviderProtocol {
    var jsonFileNameMap: [String: String] { get }
    func filename(for path: String) -> String?
}

struct LocalJSONProvider: LocalJSONProviderProtocol {
    var jsonFileNameMap: [String : String]

    init() {
        self.jsonFileNameMap = [
            CryptoCoinsEndpoint().path : CryptoCoinsEndpoint().localJSONFileName
        ]
    }

    func filename(for path: String) -> String? {
        jsonFileNameMap[path]
    }
}
