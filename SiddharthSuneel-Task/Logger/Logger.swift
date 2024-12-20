//
//  Logger.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 16/12/24.
//

import Foundation

protocol Logger {
    func log(_ message: String)
}

// Default implementation using NSLog
struct DefaultLogger: Logger {
    func log(_ message: String) {
        NSLog(message)
    }
}

public enum LogLevel: Int {
    case verbose
    case info
    case debug
    case error
    case fatal

    public static var defaultLogLevel: LogLevel {
        return LogLevel.error
    }

    func emoji() -> String {
        var output = ""
        switch self {
        case .verbose:
            output = "ℹ️"
        case .info:
            output = "ℹ️"
        case .error, .fatal:
            output = "❌"
        case .debug:
            output = "⚠️"
        }
        output += " "
        output += toString()
        return output
    }

    func toString() -> String {
        switch self {
        case .verbose:
            return "verbose"
        case .info:
            return "info"
        case .error:
            return "error"
        case .fatal:
            return "fatal"
        case .debug:
            return "debug"
        }
    }
}

func CLog(
    _ object: Any,
    info: [String: String]? = nil,
    logLevel: LogLevel = LogLevel.verbose,
    functionName: String = #function,
    fileName: String = #file,
    lineNumber: Int = #line,
    logger: Logger = DefaultLogger()) {

    guard logLevel.rawValue >= LogLevel.defaultLogLevel.rawValue else {
        return
    }

    let prefix = ""
    let className = (fileName as NSString).lastPathComponent
    var logString = "\(logLevel.emoji()) : \(prefix) <\(className)> \(functionName) [#\(lineNumber)]| \(object)"
    // Add traceId into local log message.
    if let info = info {
        logString += "\nInfo: \(info)"
    }
    logString += "\n"
    logger.log(logString)
}
