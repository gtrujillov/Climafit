//
//  WeatherRepositoryImpl.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import Foundation

struct WeatherRepositoryImpl: WeatherRepository {
    
    let apiClient: WeatherAPIClient
    
    func fetchWeather(lat: Double, lon: Double) async -> Weather {
        do {
            let dto = try await apiClient.getWeather(lat: lat, lon: lon)
            return Weather(
                temperature: dto.main.temp,
                humidity: Int(dto.main.temp),
                windSpeed: Double(dto.main.humidity),
                description: dto.weather.first?.description ?? "-",
                icon: dto.weather.first?.icon ?? "sun.max.fill",
                name: dto.name
            )
        } catch {
            return Weather(
                temperature: 0.0,
                humidity: 0,
                windSpeed: 0,
                description: "-",
                icon: "xmark.octagon",
                name: ""
            )
        }
    }
}
