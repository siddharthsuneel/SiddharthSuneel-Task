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
    private let repository: CryptoListRepositoryProtocol
    private var allCryptoList: [CryptoCoinProtocol] = []
    private var filteredCryptoList: [CryptoCoinProtocol] = []

    var observer: (_ refreshState: CryptoListViewModelObservationState) -> Void = {_ in }

    init(repository: CryptoListRepositoryProtocol = CryptoListRepository()) {
        self.repository = repository
    }

    func fetchCryptoList() {
        repository.fetchCryptoList { [weak self] (result: Result<[CryptoCoinProtocol], NetworkError>) in
            guard let `self` = self else { return }
            switch result {
            case .success(let coins):
                self.updateCoinListDataSource(coins)
                self.observer(.success)
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
    func updateCoinListDataSource(_ list: [CryptoCoinProtocol]) {
        allCryptoList = list
        filteredCryptoList = list
    }
}
