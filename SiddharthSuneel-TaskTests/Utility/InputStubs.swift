//
//  InputStubs.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 18/12/24.
//

import Foundation
@testable import SiddharthSuneel_Task

struct InputStubs {
    static let expectedCryptoCount = 6
    static let expectedErrorMsg = "Failed to fetch."
}

struct MockCoinList {
    static func list() -> Result<[CryptoCoinProtocol], NetworkError>? {
        guard let mockResponse = MockJSONManager.readMockJSONData(fromFile: CryptoCoinsEndpoint().localJSONFileName)
        else {
            return nil
        }
        do {
            let response = try JSONDecoder().decode([CryptoCoinResponse].self, from: mockResponse)
            return .success(transformResponse(response))
        } catch let error {
            return .failure(.decodingError(error))
        }
    }

    static func transformResponse(_ response: [CryptoCoinResponse]) -> [CryptoCoinProtocol] {
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
