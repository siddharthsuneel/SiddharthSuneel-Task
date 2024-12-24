//
//  NetworkManagerTests.swift
//  SiddharthSuneel-TaskTests
//
//  Created by Siddharth Suneel on 17/12/24.
//

import XCTest
@testable import SiddharthSuneel_Task

final class NetworkManagerTests: XCTestCase {
    private let mockSession = URLSessionMock()
    private let url = CryptoCoinsEndpoint().url!
    private let localJSONProvider = LocalJSONProvider()
    private var sut: NetworkManager!
    private var expectedData: Data?

    override func setUpWithError() throws {
        let filename = localJSONProvider.filename(for: CryptoCoinsEndpoint().path)!
        expectedData = MockJSONManager.readMockJSONData(fromFile: filename)
        mockSession.data = expectedData
        mockSession.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        sut = NetworkManager(session: mockSession)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testRequest() {
        let expectation = self.expectation(description: "Completion handler invoked")
        sut.request(endpoint: CryptoCoinsEndpoint()) { (result: Result<[CryptoCoinResponse], NetworkError>) in
            switch result {
            case .success(let coins):
                XCTAssertEqual(coins.count, 6)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testDataTask() {
        let expectation = self.expectation(description: "Completion handler invoked")
        let task = mockSession.dataTask(
            with: URLRequest(url: url)) { [weak self] data, response, error in
            XCTAssertEqual(data, self?.expectedData)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        task.resume()
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
