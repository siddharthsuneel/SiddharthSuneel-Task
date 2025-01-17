//
//  MockJSONManager.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 17/12/24.
//

import Foundation
@testable import SiddharthSuneel_Task

final class MockJSONManager {
    private static let testBundle = Bundle(for: MockJSONManager.self)

    class func readMockJSONData(fromFile fileName: String) -> Data? {
        let url = testBundle.url(forResource: fileName, withExtension: "json")
        do {
            if let _url = url {
                let data = try Data(contentsOf: _url)
                return data
            }else {
                return nil
            }
        } catch let error {
            CLog("Error while reading from local JSON: \(error)", logLevel: .error)
            return nil
        }
    }
}
