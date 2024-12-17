//
//  CryptoListViewModel.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 17/12/24.
//

import Foundation

enum CryptoListViewModelObservationState {
    case reloadList
    case success
    case showError(message: String)
}

class CryptoListViewModel {
    private let networkManager: NetworkServiceProtocol
    private var coinList: [CryptoCoinProtocol] = []

    var observer: (_ refreshState: CryptoListViewModelObservationState) -> Void = {_ in }

    init(networkManager: NetworkServiceProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchCryptoList() {
        networkManager.request(endpoint: CryptoCoinsEndpoint()) { [weak self] (result: Result<[CryptoCoin], NetworkError>) in
            guard let `self` = self else { return }
            switch result {
            case .success(let coins):
                print("Fetched Coins:", coins)
                self.updateCoinListDataSource(coins)
            case .failure(let error):
                print("Error:", error)
            }
        }
    }

    private func updateCoinListDataSource(_ list: [CryptoCoinProtocol]) {
        coinList = list
    }
}
