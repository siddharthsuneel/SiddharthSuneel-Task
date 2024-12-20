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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = CryptoListViewModel(networkManager: MockNetworkManager())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testFetchCryptoListSuccess() {
        sut.observer = { [weak self] (state) in
            XCTAssertNotNil(state)
            switch state {
            case .reloadList, .success:
                let dataCount = self?.sut.numberOfRows()
                XCTAssertEqual(dataCount, InputStubs.expectedCryptoCount)
            case .showError(let message):
                XCTAssertNil(message)
            }
        }
        sut.fetchCryptoList()
    }

    func testFilterCryptoList() {
        let expectation = self.expectation(description: "Completion handler invoked")
        func performFilter() {
            sut.filterCryptoList(with: "Bit")
        }

        func runFilterUT() {
            XCTAssertEqual(sut.numberOfRows(), 1)
            XCTAssertEqual(sut.cellModel(for: IndexPath(row: 0, section: 0))?.name, "Bitcoin")
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
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
