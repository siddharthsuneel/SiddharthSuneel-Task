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

    private var searchWorkItem: DispatchWorkItem?
    private var searchController: UISearchController {
        let _searchController = UISearchController(searchResultsController: nil)
        _searchController.searchBar.delegate = self
        _searchController.searchBar.sizeToFit()
        _searchController.searchBar.placeholder = Constants.searchbarPlaceholder
        _searchController.obscuresBackgroundDuringPresentation = false
        return _searchController
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
        fetchData()
    }

    func setupNavigationBar() {
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
                    default: break //self?.searchBar.becomeFirstResponder()
                    }
                }
            }
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
