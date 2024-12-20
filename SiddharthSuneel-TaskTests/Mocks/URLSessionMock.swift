//
//  URLSessionMock.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 18/12/24.
//

import Foundation

class URLSessionMock: URLSession, @unchecked Sendable {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskMock {
            completionHandler(self.data, self.response, self.error)
        }
        return task
    }
}

class URLSessionDataTaskMock: URLSessionDataTask, @unchecked Sendable {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}
