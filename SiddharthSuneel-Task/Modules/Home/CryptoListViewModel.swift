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
    private var allCryptoList: [CryptoCoinProtocol] = []
    private var filteredCryptoList: [CryptoCoinProtocol] = []

    var observer: (_ refreshState: CryptoListViewModelObservationState) -> Void = {_ in }

    init(networkManager: NetworkServiceProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchCryptoList() {
        networkManager.request(endpoint: CryptoCoinsEndpoint()) { [weak self] (result: Result<[CryptoCoinResponse], NetworkError>) in
            guard let `self` = self else { return }
            switch result {
            case .success(let coins):
                self.transforResponseModel(coins)
            case .failure(let error):
                CLog("Error while fetching crypto list\(error)", logLevel: .error)
                self.observer(.showError(message: "Failed to fetch."))
            }
        }
    }

    func numberOfRows() -> Int {
        return filteredCryptoList.count
    }

    func cellModel(for indexPath: IndexPath) -> CryptoCoinProtocol? {
        guard indexPath.row < filteredCryptoList.count else {
            return nil
        }
        return filteredCryptoList[indexPath.row]
    }

    func searchInCryptoList(with query: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let filtered = self.allCryptoList.filter { crypto in
                crypto.name?.lowercased().hasPrefix(query.lowercased()) ?? false ||
                crypto.symbol?.lowercased().hasPrefix(query.lowercased()) ?? false
            }
            DispatchQueue.main.async {
                self.filteredCryptoList = query.isEmpty ? self.allCryptoList : filtered
                self.observer(.reloadList)
            }
        }
    }

    func cancelSearching() {
        guard filteredCryptoList.count != allCryptoList.count else {
            return
        }
        DispatchQueue.main.async {
            self.filteredCryptoList = self.allCryptoList
            self.observer(.reloadList)
        }
    }
}

private extension CryptoListViewModel {
    func transforResponseModel(_ response: [CryptoCoinResponse]) {
        var list: [CryptoCoinProtocol] = []
        response.forEach { response in
            let model = CryptoCoin(
                name: response.name,
                symbol: response.symbol,
                isNew: response.isNew,
                isActive: response.isActive,
                type: response.type ?? "")
            list.append(model)
        }
        self.updateCoinListDataSource(list)
    }

    func updateCoinListDataSource(_ list: [CryptoCoinProtocol]) {
        allCryptoList = list
        filteredCryptoList = list
        observer(.success)
    }
}
