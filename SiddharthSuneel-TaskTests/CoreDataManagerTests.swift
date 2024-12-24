//
//  CoreDataManagerTests.swift
//  SiddharthSuneel-TaskTests
//
//  Created by Siddharth Suneel on 20/12/24.
//

import XCTest
import CoreData
@testable import SiddharthSuneel_Task

final class CoreDataManagerTests: XCTestCase {

    var sut: CoreDataManager!
    var mockPersistentContainer: NSPersistentContainer!

    override func setUpWithError() throws {
        // Initialize Core Data stack for testing
        mockPersistentContainer = NSPersistentContainer(name: DBConstants.persistentDBContainer)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        mockPersistentContainer.persistentStoreDescriptions = [description]
        mockPersistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load test store: \(error)")
            }
        }

        sut = CoreDataManager(persistentContainer: mockPersistentContainer)
    }

    override func tearDownWithError() throws {
        let model = mockPersistentContainer.managedObjectModel
        for entity in model.entities {
            print("Sid, Entity: \(entity.name ?? "Unnamed"), Class: \(entity.managedObjectClassName ?? "No class")")
        }
        sut = nil
        mockPersistentContainer = nil
    }

    func testloadCryptoList() {
        // Create test data
        let context = mockPersistentContainer.viewContext
        let entity = CryptoListEntity(context: context)
        entity.name = "Ripple-T"
        entity.symbol = "XRP"
        entity.isNew = false
        entity.isActive = true
        entity.type = CryptoType.coin.rawValue
        try? context.save()

        // Perform fetch
        let cryptoCoins = sut.loadCryptoList()

        // Assert results
        XCTAssertFalse(cryptoCoins.isEmpty, "Expected readings to be fetched")
        XCTAssertEqual(cryptoCoins.count, 1, "Expected one reading to be fetched")
        XCTAssertEqual(cryptoCoins.first?.symbol, "XRP", "Expected fetched crypto coin to match")
    }
}
