//
//  ViewController.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 16/12/24.
//

import UIKit

class CryptoCoinsListVC: BaseViewController {
    @IBOutlet private weak var coinTableView: UITableView!
    
    private let viewModel = CryptoListViewModel()
    private var filterView: CryptoFilterView?
    private var bottomConstraint: NSLayoutConstraint?

    private var searchWorkItem: DispatchWorkItem?
    private var searchController: UISearchController {
        let _searchController = UISearchController(searchResultsController: nil)
        _searchController.searchBar.delegate = self
        _searchController.searchBar.sizeToFit()
        _searchController.searchBar.placeholder = Constants.searchbarPlaceholder
        _searchController.obscuresBackgroundDuringPresentation = false
        return _searchController
    }

    private var filterButton: UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "filterIcon"), for: .normal)
        button.titleLabel?.textColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        return button
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
}

private extension CryptoCoinsListVC {
    func setup() {
        addObservers()
        setupNavigationBar()
        registerTableViewCells()
        setupFilterView()
        fetchData()
    }

    func setupFilterView() {
        filterView = CryptoFilterView.createView()
        filterView?.isHidden = true
        filterView?.delegate = self
        filterView?.initialise()
        filterView?.frame = CGRect(
            x: .zero,
            y: view.frame.height + Constants.filterViewHeight,
            width: .zero,
            height: .zero)
        self.view.addSubview(filterView!)

        filterView?.translatesAutoresizingMaskIntoConstraints = false
        filterView?.heightAnchor.constraint(equalToConstant: Constants.filterViewHeight).isActive = true
        filterView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        filterView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = filterView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.filterViewHeight)
        bottomConstraint?.isActive = true
    }

    func setupNavigationBar() {
        let filterButton = UIBarButtonItem(customView: filterButton)
        filterButton.tintColor = .black

        navigationItem.rightBarButtonItem = filterButton
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    func fetchData() {
        showActivityIndicator()
        viewModel.fetchCryptoList()
    }

    func registerTableViewCells() {
        coinTableView.register(CryptoTVCell.self)
    }

    func addObservers() {
        viewModel.observer =  { [weak self] (state) in
            self?.hideActivityIndicator()
            switch state {
            case .reloadList, .success:
                DispatchQueue.main.async {
                    self?.coinTableView.reloadData()
                }
            case .showError(let message):
                CommonUtils.showOkAlertWithTitle("", message: message) { (style) in
                    switch style {
                    default: break
                    }
                }
            }
        }
    }

    @objc private func didTapFilterButton() {
        var isShowingAnimation = true
        if filterView?.isHidden ?? false {
            filterView?.isHidden = false
            bottomConstraint?.constant = .zero
        } else {
            isShowingAnimation = false
            bottomConstraint?.constant = Constants.filterViewHeight
        }

        UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
            var tableViewInsets = self.coinTableView.contentInset
            if isShowingAnimation {
                tableViewInsets.bottom = Constants.filterViewHeight
            } else {
                self.filterView?.isHidden = true
                tableViewInsets.bottom = .zero
            }
            self.coinTableView.contentInset = tableViewInsets
        }
    }
}

extension CryptoCoinsListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CryptoTVCell.reusableIdentifier) as? CryptoTVCell else {
            return UITableViewCell()
        }
        cell.injectModel(model: viewModel.cellModel(for: indexPath))
        return cell
    }
}

extension CryptoCoinsListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.viewModel.searchInCryptoList(with: searchText)
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cancelSearching()
        searchController.isActive = false
    }
}

extension CryptoCoinsListVC: CryptoFilterViewDelegate {
    func didUpdateFilters(options: [Constants.CryptoFilterOption]) {
        viewModel.applyFilter(options: options)
    }
}
