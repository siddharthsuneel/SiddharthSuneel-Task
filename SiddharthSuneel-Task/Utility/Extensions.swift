//
//  Extensions.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 16/12/24.
//

import UIKit

extension UITableViewCell {
    static var reusableIdentifier: String {
        return String(describing: self)
    }

    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reusableIdentifier)
    }
}
