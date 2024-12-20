//
//  CryptoRepository.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 20/12/24.
//

import Foundation

protocol CryptoListRepositoryProtocol {
    func fetchCryptoList(completion: @escaping (Result<[CryptoCoinProtocol], NetworkError>) -> Void)
}

class CryptoListRepository: CryptoListRepositoryProtocol {
    private let networkManager: NetworkServiceProtocol
    private let localStorage: LocalCryptoListDataManagerProtocol

    init(
        networkManager: NetworkServiceProtocol = NetworkManager(),
        localStorage: LocalCryptoListDataManagerProtocol = LocalCryptoListDataManager()
    ) {
        self.networkManager = networkManager
        self.localStorage = localStorage
    }

    func fetchCryptoList(completion: @escaping (Result<[CryptoCoinProtocol], NetworkError>) -> Void) {
        guard ReachabilityManager.isNetworkReachable() else {
            fetchDataFromLocal(completion: completion)
            return
        }
        networkManager.request(endpoint: CryptoCoinsEndpoint()) { [weak self] (result: Result<[CryptoCoinResponse], NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let coins):
                let models = self.transformResponse(coins)
                self.localStorage.saveCryptoList(models)
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension CryptoListRepository {
    func fetchDataFromLocal(completion: @escaping (Result<[CryptoCoinProtocol], NetworkError>) -> Void) {
        let offlineData = self.localStorage.loadCryptoList()
        completion(.success(offlineData))
    }

    func transformResponse(_ response: [CryptoCoinResponse]) -> [CryptoCoinProtocol] {
       return response.map {
           CryptoCoin(
               name: $0.name,
               symbol: $0.symbol,
               isNew: $0.isNew,
               isActive: $0.isActive,
               type: $0.type ?? "")
       }
   }
}
