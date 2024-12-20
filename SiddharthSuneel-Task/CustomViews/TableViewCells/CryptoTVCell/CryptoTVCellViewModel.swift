//
//  CryptoTVCellViewModel.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 19/12/24.
//

import Foundation

class CryptoTVCellViewModel {
    private var cellModel: CryptoCoinProtocol?

    init(cellModel: CryptoCoinProtocol? = nil) {
        self.cellModel = cellModel
    }

    var cryptoName: String? {
        cellModel?.name
    }

    var symbol: String? {
        cellModel?.symbol
    }

    var cryptoIconImgName: String {
        cellModel?.iconName ?? ""
    }

    var newBadgeIconImgName: String? {
        guard
            let isNew = cellModel?.isNew,
            isNew
        else {
            return nil
        }
        return "newBanner"
    }


    func setCellModel(model: CryptoCoinProtocol?) {
        self.cellModel = model
    }
}
