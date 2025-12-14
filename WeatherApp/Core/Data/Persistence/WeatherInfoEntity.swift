//
//  WeatherInfoEntity.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import CoreData

// MARK: - WeatherInfoEntity

@objc(WeatherInfoEntity)
public class WeatherInfoEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var weatherDescription: String
    @NSManaged public var temperature: Double
    @NSManaged public var humidity: Int16
    @NSManaged public var iconCode: String
    @NSManaged public var requestDate: Date
    @NSManaged public var city: CityEntity?
}

extension WeatherInfoEntity {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<WeatherInfoEntity> {
        NSFetchRequest<WeatherInfoEntity>(entityName: "WeatherInfoEntity")
    }
}

extension WeatherInfoEntity {
    var toDomain: Weather {
        Weather(
            id: id,
            description: weatherDescription,
            temperature: temperature,
            humidity: Int(humidity),
            iconCode: iconCode,
            requestDate: requestDate
        )
    }

    func update(from weather: Weather) {
        id = weather.id
        weatherDescription = weather.description
        temperature = weather.temperature
        humidity = Int16(weather.humidity)
        iconCode = weather.iconCode
        requestDate = weather.requestDate
    }
}
