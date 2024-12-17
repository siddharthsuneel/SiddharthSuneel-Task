//
//  NetworkConfig.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 16/12/24.
//

import Foundation

struct NetworkConfig {
    static let baseURL = URL(string: "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io")!

    static let commonHeaders: [String: String] = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
}
