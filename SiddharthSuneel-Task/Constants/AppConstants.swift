//
//  AppConstants.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 19/12/24.
//

enum Constants {
    static let searchbarPlaceholder = "Search here..."
    static let filterViewHeight = 150.0

    enum CryptoFilterOption: String, CaseIterable {
        case onlyCoins = "Only Coins"
        case onlyTokens = "Only Tokens"
        case onlyActive = "Only Active"
        case onlyInActive = "Only Inactive"
        case onlyNewCoins = "Only New Coins"
    }
}
