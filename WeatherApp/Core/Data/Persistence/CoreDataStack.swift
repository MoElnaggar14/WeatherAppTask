//
//  CoreDataStack.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import CoreData

@MainActor
final class CoreDataStack: Sendable {
    static let shared = CoreDataStack()

    private let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "WeatherApp")

        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }

        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    }

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    nonisolated func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        return context
    }

    func saveContext(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        try context.save()
    }

    func deleteAllData() async throws {
        let context = viewContext

        let cityFetchRequest: NSFetchRequest<NSFetchRequestResult> = CityEntity.fetchRequest()
        let cityDeleteRequest = NSBatchDeleteRequest(fetchRequest: cityFetchRequest)
        try context.execute(cityDeleteRequest)

        let weatherFetchRequest: NSFetchRequest<NSFetchRequestResult> = WeatherInfoEntity.fetchRequest()
        let weatherDeleteRequest = NSBatchDeleteRequest(fetchRequest: weatherFetchRequest)
        try context.execute(weatherDeleteRequest)

        try saveContext(context)
    }
}
