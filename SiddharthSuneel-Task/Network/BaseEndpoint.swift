//
//  BaseEndpoint.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 16/12/24.
//

import Foundation

class BaseEndpoint: Requestable {
    var path: String
    var method: HTTPMethod
    var body: Data?
    var additionalHeaders: [String: String]?

    init(path: String, method: HTTPMethod, body: Data? = nil, additionalHeaders: [String: String]? = nil) {
        self.path = path
        self.method = method
        self.body = body
        self.additionalHeaders = additionalHeaders
    }

    var url: URL? {
        NetworkConfig.baseURL.appendingPathComponent(path)
    }

    var headers: [String: String]? {
        var headers = NetworkConfig.commonHeaders
        additionalHeaders?.forEach { headers[$0.key] = $0.value }
        return headers
    }
}
