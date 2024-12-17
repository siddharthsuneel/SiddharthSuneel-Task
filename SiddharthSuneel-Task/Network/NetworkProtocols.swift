//
//  NetworkProtocols.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 16/12/24.
//

import Foundation

protocol Requestable {
    var url: URL? { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: Requestable,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
