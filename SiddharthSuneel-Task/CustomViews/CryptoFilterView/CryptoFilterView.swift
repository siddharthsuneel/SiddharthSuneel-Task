//
//  CryptoFilterView.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 24/12/24.
//

import UIKit

protocol CryptoFilterViewDelegate: AnyObject {
    func didUpdateFilters(options: [Constants.CryptoFilterOption])
}

class CryptoFilterView: UIView {
    private let viewModel = CryptoFilterViewModel()
    weak var delegate: CryptoFilterViewDelegate?
    @IBOutlet private weak var collectionView: UICollectionView?

    func initialise() {
        collectionView?.register(CryptoFilterCVCell.self)
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        collectionView?.delegate = self
        collectionView?.dataSource = self

        viewModel.observer = { [weak self] state in
            switch state {
            case .filterUpdated(let selectedFilters):
                self?.collectionView?.reloadData()
                self?.delegate?.didUpdateFilters(options: selectedFilters)
            }
        }
    }

    static func createView() -> CryptoFilterView? {
        return Bundle.main.loadNibNamed(CryptoFilterView.nibName, owner: self, options: nil)?.first as? CryptoFilterView
    }
}

extension CryptoFilterView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CryptoFilterCVCell.reusableIdentifier,
            for: indexPath) as? CryptoFilterCVCell else {
            return UICollectionViewCell()
        }
        let title = viewModel.titleText(for: indexPath)
        let isSelected = viewModel.isFilterSelected(for: indexPath)
        cell.setup(with: title, isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelect(itemAt: indexPath)
    }
}
