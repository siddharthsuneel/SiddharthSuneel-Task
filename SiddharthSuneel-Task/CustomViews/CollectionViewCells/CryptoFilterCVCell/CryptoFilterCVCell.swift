//
//  CryptoFilterCVCell.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 24/12/24.
//

import UIKit

class CryptoFilterCVCell: UICollectionViewCell {
    @IBOutlet weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        button?.setTitle(nil, for: .normal)
        updateUI(for: false)
    }

    func setup(with title: String, _ isSelected: Bool) {
        button?.setTitle(title, for: .normal)
        button?.setTitleColor(.black, for: .normal)
        updateUI(for: isSelected)
    }

    private func updateUI(for selection: Bool) {
        if selection {
            layer.borderWidth = 1.0
            layer.borderColor = UIColor.black.cgColor
            layer.cornerRadius = 2.0
            backgroundColor = UIColor.gray.withAlphaComponent(1.0)
        } else {
            backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            layer.borderColor = UIColor.clear.cgColor
        }
    }
}
