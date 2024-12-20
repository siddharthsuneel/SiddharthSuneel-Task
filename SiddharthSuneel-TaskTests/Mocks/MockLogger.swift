//
//  MockLogger.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 18/12/24.
//

import XCTest
@testable import SiddharthSuneel_Task

class MockLogger: Logger {
    var loggedMessages: [String] = []

    func log(_ message: String) {
        loggedMessages.append(message)
    }

    func contains(_ substring: String) -> Bool {
        loggedMessages.contains { $0.contains(substring) }
    }
}
