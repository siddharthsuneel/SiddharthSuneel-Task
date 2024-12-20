//
//  CryptoTVCell.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 19/12/24.
//

import UIKit

class CryptoTVCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var cryptoIconImageView: UIImageView!
    @IBOutlet private weak var newBadgeIconImageView: UIImageView!

    private let viewModel = CryptoTVCellViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        cryptoIconImageView.image = nil
        newBadgeIconImageView.image = nil
    }

    func injectModel(model: CryptoCoinProtocol?) {
        viewModel.setCellModel(model: model)
        setDataInView()
    }

    private func setup() {
        selectionStyle = .none
    }

    private func setDataInView() {
        nameLabel.text = viewModel.cryptoName
        symbolLabel.text = viewModel.symbol
        cryptoIconImageView.image = UIImage(named: viewModel.cryptoIconImgName)
        if let newBadgeIconImgName = viewModel.newBadgeIconImgName {
            newBadgeIconImageView.image = UIImage(named: newBadgeIconImgName)
        }
    }
}
