//
//  ViewController.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 16/12/24.
//

import UIKit

class HomeViewController: UIViewController {

    let networkManager = NetworkManager()
    let getCryptoCoins = CryptoCoinsEndpoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchData()
    }

    func fetchData() {


        networkManager.request(endpoint: getCryptoCoins) { (result: Result<[CryptoCoins], NetworkError>) in
            switch result {
            case .success(let coins):
                print("Fetched Coins:", coins)
            case .failure(let error):
                print("Error:", error)
            }
        }
    }

}

