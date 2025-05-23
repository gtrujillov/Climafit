//
//  GetWeatherUseCase.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import Foundation

protocol GetWeatherUseCase {
    func execute(lat: Double, lon: Double) async -> Weather
}

struct GetWeatherUseCaseImpl: GetWeatherUseCase {
    let repository: WeatherRepository

    func execute(lat: Double, lon: Double) async -> Weather {
        await repository.fetchWeather(lat: lat, lon: lon)
    }
}
