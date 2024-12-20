//
//  MockNetworkManager.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 17/12/24.
//

import Foundation
@testable import SiddharthSuneel_Task

class MockNetworkManager: NetworkServiceProtocol {
    private let localJSONProvider = LocalJSONProvider()

    func request<T>(endpoint: Requestable, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        serveFromLocalJSON(endpoint: endpoint, completion: completion)
    }

    private func serveFromLocalJSON<T: Decodable>(endpoint: Requestable, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let incomingUrl = endpoint.url?.path() else {
            completion(.failure(.invalidURL))
            return
        }
        guard let filename = localJSONProvider.filename(for: incomingUrl) else {
            completion(.failure(.mockJSONNotFound))
            return
        }
        if let mockResponse = MockJSONManager.readMockJSONData(fromFile: filename) {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: mockResponse)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(.decodingError(error)))
            }
        } else {
            completion(.failure(.mockJSONNotFound))
        }
    }
}
