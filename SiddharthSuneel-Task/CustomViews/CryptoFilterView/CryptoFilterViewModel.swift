//
//  CryptoFilterViewModel.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 24/12/24.
//

import Foundation

enum CryptoFilterViewModelObservationState {
    case filterUpdated([Constants.CryptoFilterOption])
}

class CryptoFilterViewModel {
    private let dataSource: [Constants.CryptoFilterOption]
    private var selectedFilters: [Constants.CryptoFilterOption] = []
    var observer: (_ refreshState: CryptoFilterViewModelObservationState) -> Void = {_ in }

    init(dataSource: [Constants.CryptoFilterOption] = Constants.CryptoFilterOption.allCases) {
        self.dataSource = dataSource
    }

    func numberOfItems() -> Int {
        dataSource.count
    }

    func titleText(for indexPath: IndexPath) -> String {
        guard indexPath.row < dataSource.count else {
            return ""
        }
        return dataSource[indexPath.row].rawValue
    }

    func isFilterSelected(for indexPath: IndexPath) -> Bool {
        guard indexPath.row < dataSource.count else {
            return false
        }
        let item = dataSource[indexPath.row]
        return selectedFilters.contains(item)
    }

    func didSelect(itemAt indexPath: IndexPath) {
        guard indexPath.row < dataSource.count else {
            return
        }
        let selectedItem = dataSource[indexPath.row]
        if selectedFilters.contains(selectedItem) {
            selectedFilters.removeAll { $0 == selectedItem }
        } else {
            selectedFilters.append(selectedItem)
        }
        observer(.filterUpdated(selectedFilters))
    }
}
