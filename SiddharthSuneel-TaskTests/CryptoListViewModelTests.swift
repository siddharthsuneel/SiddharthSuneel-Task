//
//  CryptoListViewModelTests.swift
//  SiddharthSuneel-TaskTests
//
//  Created by Siddharth Suneel on 18/12/24.
//

import XCTest
@testable import SiddharthSuneel_Task

final class CryptoListViewModelTests: XCTestCase {
    var sut: CryptoListViewModel!
    var mockRepository: MockCryptoListRepository!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockRepository = MockCryptoListRepository()
        sut = CryptoListViewModel(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testFetchCryptoListSuccess() {
        let expectation = self.expectation(description: "Completion handler invoked")
        mockRepository.result = MockCoinList.list()
        sut.observer = { [weak self] (state) in
            XCTAssertNotNil(state)
            switch state {
            case .reloadList, .success:
                let dataCount = self?.sut.numberOfRows()
                XCTAssertEqual(dataCount, InputStubs.expectedCryptoCount)
                expectation.fulfill()
            case .showError(let message):
                XCTAssertNil(message)
            }
        }
        sut.fetchCryptoList()
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testFetchCryptoListFailure() {
        let expectation = self.expectation(description: "Completion handler invoked")
        mockRepository.result = .failure(.invalidResponse)
        sut.observer = { (state) in
            XCTAssertNotNil(state)
            switch state {
            case .reloadList, .success: break
            case .showError(let message):
                XCTAssertNotNil(message)
                XCTAssertEqual(message, InputStubs.expectedErrorMsg)
                expectation.fulfill()
            }
        }
        sut.fetchCryptoList()
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testFilterCryptoList() {
        mockRepository.result = MockCoinList.list()
        let expectation = self.expectation(description: "Completion handler invoked")
        func performSearch() {
            sut.searchInCryptoList(with: "Bit")
        }

        func runSearchUT() {
            XCTAssertEqual(sut.numberOfRows(), 1)
            XCTAssertEqual(sut.cellModel(for: IndexPath(row: 0, section: 0))?.name, "Bitcoin")
            expectation.fulfill()
        }

        sut.observer = { (state) in
            XCTAssertNotNil(state)
            switch state {
            case .success:
                performSearch()
            case .reloadList:
                runSearchUT()
            case .showError(let message):
                XCTAssertNil(message)
            }
        }
        sut.fetchCryptoList()
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testCancelSearching() {
        var reloadCount = 0
        mockRepository.result = MockCoinList.list()
        let expectation = self.expectation(description: "Completion handler invoked")
        func performSearch() {
            sut.searchInCryptoList(with: "Ri")
        }
        func performSearchCancel() {
            sut.cancelSearching()
        }

        func runCancelSearchUT() {
            XCTAssertEqual(sut.numberOfRows(), InputStubs.expectedCryptoCount)
            expectation.fulfill()
        }

        sut.observer = { (state) in
            XCTAssertNotNil(state)
            switch state {
            case .success:
                performSearch()
            case .reloadList:
                reloadCount += 1
                performSearchCancel()
                if reloadCount == 2 {
                    runCancelSearchUT()
                }
            case .showError(let message):
                XCTAssertNil(message)
            }
        }
        sut.fetchCryptoList()
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testApplyFilter_WithOnlyActive() {
        mockRepository.result = MockCoinList.list()
        let expectation = self.expectation(description: "Completion handler invoked")
        func performFilter() {
            sut.applyFilter(options: [.onlyActive, .onlyNewCoins])
        }

        func runFilterUT() {
            XCTAssertEqual(sut.numberOfRows(), 1)
            XCTAssertEqual(sut.cellModel(for: IndexPath(row: 0, section: 0))?.name, "Cardano")
            expectation.fulfill()
        }

        sut.observer = { (state) in
            XCTAssertNotNil(state)
            switch state {
            case .success:
                performFilter()
            case .reloadList:
                runFilterUT()
            case .showError(let message):
                XCTAssertNil(message)
            }
        }
        sut.fetchCryptoList()
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
