//
//  LoggerTests.swift
//  SiddharthSuneel-TaskTests
//
//  Created by Siddharth Suneel on 18/12/24.
//

import XCTest
@testable import SiddharthSuneel_Task

final class LoggerTests: XCTestCase {
    func testCLog_logsMessageWhenLogLevelIsAboveDefault() {
        let mockLogger = MockLogger()
        let testObject = "Test log message"
        let testLogLevel: LogLevel = .error
        let testFunctionName = "testFunction"
        let testFileName = "TestFile.swift"
        let testLineNumber = 42
        let testInfo = ["some_key": "some_value"]

        let expectedLog = "❌ error :  <\(testFileName)> \(testFunctionName) [#\(testLineNumber)]| \(testObject)"

        CLog(
            testObject,
            info: testInfo,
            logLevel: testLogLevel,
            functionName: testFunctionName,
            fileName: testFileName,
            lineNumber: testLineNumber,
            logger: mockLogger
        )

        XCTAssertTrue(mockLogger.contains(expectedLog), "Expected log message not found in MockLogger.")
    }

    func testCLog_doesNotLogWhenLogLevelIsBelowDefault() {
        let mockLogger = MockLogger()
        let testObject = "This should not be logged"
        let testLogLevel: LogLevel = .verbose  // Default log level is .error

        CLog(testObject, logLevel: testLogLevel, logger: mockLogger)

        XCTAssertTrue(mockLogger.loggedMessages.isEmpty, "No log messages should be recorded when the log level is below default.")
    }
}
