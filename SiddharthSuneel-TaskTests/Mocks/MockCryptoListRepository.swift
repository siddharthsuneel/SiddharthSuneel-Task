//
//  MockCryptoListRepository.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 20/12/24.
//

@testable import SiddharthSuneel_Task

class MockCryptoListRepository: CryptoListRepositoryProtocol {
    var result: Result<[CryptoCoinProtocol], NetworkError>?

    func fetchCryptoList(completion: @escaping (Result<[CryptoCoinProtocol], NetworkError>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}

