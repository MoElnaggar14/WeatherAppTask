//
//  CoreDataLocalDataSource.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import CoreData

// MARK: - LocalDataSourceProtocol

protocol LocalDataSourceProtocol: Sendable {
    func getAllCities() async throws -> [City]
    func getCity(byName name: String) async throws -> City?
    func saveCity(_ city: City) async throws
    func deleteCity(_ city: City) async throws
}

// MARK: - CoreDataLocalDataSource

@MainActor
final class CoreDataLocalDataSource: LocalDataSourceProtocol, Sendable {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }

    func getAllCities() async throws -> [City] {
        let context = coreDataStack.viewContext
        let fetchRequest: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        let entities = try context.fetch(fetchRequest)
        return entities.map(\.toDomain)
    }

    func getCity(byName name: String) async throws -> City? {
        let context = coreDataStack.viewContext
        let fetchRequest: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1

        let entities = try context.fetch(fetchRequest)
        return entities.first?.toDomain
    }

    func saveCity(_ city: City) async throws {
        let context = coreDataStack.newBackgroundContext()

        try await context.perform {
            let fetchRequest = NSFetchRequest<CityEntity>(entityName: "CityEntity")
            fetchRequest.predicate = NSPredicate(format: "id == %@", city.id as CVarArg)
            fetchRequest.fetchLimit = 1

            let existingEntities = try context.fetch(fetchRequest)

            if let existingEntity = existingEntities.first {
                existingEntity.update(from: city, in: context)
            } else {
                let newEntity = CityEntity(context: context)
                newEntity.update(from: city, in: context)
            }

            if context.hasChanges {
                try context.save()
            }
        }
    }

    func deleteCity(_ city: City) async throws {
        let context = coreDataStack.newBackgroundContext()

        try await context.perform {
            let fetchRequest = NSFetchRequest<CityEntity>(entityName: "CityEntity")
            fetchRequest.predicate = NSPredicate(format: "id == %@", city.id as CVarArg)
            fetchRequest.fetchLimit = 1

            let entities = try context.fetch(fetchRequest)

            if let entity = entities.first {
                context.delete(entity)
                try context.save()
            }
        }
    }
}
