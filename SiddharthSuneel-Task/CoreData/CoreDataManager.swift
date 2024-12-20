//
//  CoreDataManager.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 20/12/24.
//

import CoreData

class CoreDataManager {
    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func saveCryptoList(_ coins: [CryptoCoinProtocol]) {
        deleteAllCryptoCoins()
        let context = persistentContainer.viewContext
        for coin in coins {
            let entity = CryptoListEntity(context: context)
            entity.name = coin.name
            entity.symbol = coin.symbol
            entity.isNew = coin.isNew ?? false
            entity.isActive = coin.isActive ?? false
            entity.type = coin.type.rawValue
        }
        saveContext()
    }

    func loadCryptoList() -> [CryptoCoinProtocol] {
        let context = persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<CryptoListEntity> = CryptoListEntity.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { entity in
                CryptoCoin(name: entity.name, symbol: entity.symbol, isNew: entity.isNew, isActive: entity.isActive, type: entity.type ?? "")
            }
        } catch {
            CLog("Error fetching data: \(error)", logLevel: .error)
            return []
        }
    }

    func deleteAllCryptoCoins() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CryptoListEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            CLog("Error deleting old data: \(error)", logLevel: .error)
        }
    }

    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                CLog("Failed to save context: \(error)", logLevel: .error)
            }
        }
    }
}
