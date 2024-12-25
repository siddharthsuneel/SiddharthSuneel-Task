//
//  Extensions.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 16/12/24.
//

import UIKit

extension UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reusableIdentifier)
    }

    func reloadData(with completion: @escaping EmptyClosure) {
        UIView.animate(
            withDuration: 0,
            animations: {
                self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reusableIdentifier)
    }
}
