//
//  NetworkEnums.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 16/12/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case parsingError
    case requestFailed(Error)
    case invalidResponse
    case mockJSONNotFound
}

