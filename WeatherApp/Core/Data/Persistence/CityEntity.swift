//
//  CityEntity.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import CoreData

// MARK: - CityEntity

@objc(CityEntity)
public class CityEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var weatherHistory: NSSet?

    @objc(addWeatherHistoryObject:)
    @NSManaged
    public func addToWeatherHistory(_ value: WeatherInfoEntity)

    @objc(removeWeatherHistoryObject:)
    @NSManaged
    public func removeFromWeatherHistory(_ value: WeatherInfoEntity)

    @objc(addWeatherHistory:)
    @NSManaged
    public func addToWeatherHistory(_ values: NSSet)

    @objc(removeWeatherHistory:)
    @NSManaged
    public func removeFromWeatherHistory(_ values: NSSet)
}

extension CityEntity {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<CityEntity> {
        NSFetchRequest<CityEntity>(entityName: "CityEntity")
    }

    var weatherHistoryArray: [WeatherInfoEntity] {
        let set = weatherHistory as? Set<WeatherInfoEntity> ?? []
        return set.sorted { $0.requestDate > $1.requestDate }
    }
}

extension CityEntity {
    var toDomain: City {
        let weatherHistory = weatherHistoryArray.map(\.toDomain)
        return City(
            id: id,
            name: name,
            weatherHistory: weatherHistory
        )
    }

    func update(from city: City, in context: NSManagedObjectContext) {
        id = city.id
        name = city.name

        if let existingWeather = weatherHistory as? Set<WeatherInfoEntity> {
            for weather in existingWeather {
                context.delete(weather)
            }
        }

        for weather in city.weatherHistory {
            let weatherEntity = WeatherInfoEntity(context: context)
            weatherEntity.update(from: weather)
            weatherEntity.city = self
            addToWeatherHistory(weatherEntity)
        }
    }

    static func create(from city: City, in context: NSManagedObjectContext) -> CityEntity {
        let entity = CityEntity(context: context)
        entity.update(from: city, in: context)
        return entity
    }
}
