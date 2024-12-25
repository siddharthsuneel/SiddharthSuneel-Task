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
    private var activeFilters: Set<Constants.CryptoFilterOption> = []

    var observer: (_ refreshState: CryptoListViewModelObservationState) -> Void = {_ in }

    init(repository: CryptoListRepositoryProtocol = CryptoListRepository()) {
        self.repository = repository
    }

    func fetchCryptoList() {
        repository.fetchCryptoList { [weak self] (result: Result<[CryptoCoinProtocol], NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let coins):
                DispatchQueue.main.async {
                    self.updateCoinListMasterDataSource(coins)
                    self.observer(.success)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    CLog("Error while fetching crypto list\(error)", logLevel: .error)
                    self.observer(.showError(message: "Failed to fetch."))
                }
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

    func applyFilter(options: [Constants.CryptoFilterOption]) {
        activeFilters.removeAll()
        options.forEach { option in
            activeFilters.insert(option)
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let filtered = self.applyActiveFilters(on: self.allCryptoList)
            DispatchQueue.main.async {
                self.filteredCryptoList = filtered
                self.observer(.reloadList)
            }
        }
    }

    private func applyActiveFilters(on list: [CryptoCoinProtocol]) -> [CryptoCoinProtocol] {
        var filteredList = list
        for filter in activeFilters {
            switch filter {
            case .onlyCoins:
                filteredList = filteredList.filter { $0.type == .coin }
            case .onlyTokens:
                filteredList = filteredList.filter { $0.type == .token }
            case .onlyActive:
                filteredList = filteredList.filter { $0.isActive == true }
            case .onlyInActive:
                filteredList = filteredList.filter { $0.isActive == false }
            case .onlyNewCoins:
                filteredList = filteredList.filter { $0.isNew == true }
            }
        }
        return filteredList
    }
}

private extension CryptoListViewModel {
    func updateCoinListMasterDataSource(_ list: [CryptoCoinProtocol]) {
        allCryptoList = list
        filteredCryptoList = list
    }
}
