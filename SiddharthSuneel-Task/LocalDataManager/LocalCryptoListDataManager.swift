//
//  LocalCryptoListDataManager.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 20/12/24.
//

import CoreData

protocol LocalCryptoListDataManagerProtocol {
    func saveCryptoList(_ coins: [CryptoCoinProtocol])
    func loadCryptoList() -> [CryptoCoinProtocol]
}

class LocalCryptoListDataManager: LocalCryptoListDataManagerProtocol {
    private let store: CoreDataManager

    init() {
        let persistentContainer = NSPersistentContainer(name: DBConstants.persistentDBContainer)
        let description = persistentContainer.persistentStoreDescriptions.first
        let options: [String: Any] = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        description?.setOption(options as NSObject, forKey: NSPersistentStoreFileProtectionKey)

        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.store = CoreDataManager(persistentContainer: persistentContainer)
    }

    func saveCryptoList(_ coins: [CryptoCoinProtocol]) {
        store.saveCryptoList(coins)
    }

    func loadCryptoList() -> [CryptoCoinProtocol] {
        return store.loadCryptoList()
    }
}
