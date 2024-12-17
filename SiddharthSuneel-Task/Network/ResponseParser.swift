//
//  ResponseParser.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 17/12/24.
//

import Foundation

protocol ResponseParserProtocol {
    func parse<T: Decodable>(data: Data, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class ResponseParser: ResponseParserProtocol {
    func parse<T: Decodable>(data: Data, completion: @escaping (Result<T, NetworkError>) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            CLog("JSON parsing failed due to \(error).", logLevel: .error)
            completion(.failure(.decodingError(error)))
        }
    }
}
