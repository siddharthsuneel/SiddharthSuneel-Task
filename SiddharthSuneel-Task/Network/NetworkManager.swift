//
//  NetworkManager.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 16/12/24.
//

import Foundation

class NetworkManager: NetworkService {
    private let session: URLSession
    private let parser: ResponseParserProtocol

    init(session: URLSession = .shared, parser: ResponseParserProtocol = ResponseParser()) {
        self.session = session
        self.parser = parser
    }

    func request<T: Decodable>(
        endpoint: Requestable,
        completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

        session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            guard let `self` = self else {
                CLog("Opps!!! Failed to unwrap weak self.", logLevel: .error)
                return
            }
            return self.parser.parse(data: data, completion: completion)
        }.resume()
    }
}
