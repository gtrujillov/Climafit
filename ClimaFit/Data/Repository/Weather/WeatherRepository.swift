//
//  WeatherRepository.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import Foundation

protocol WeatherRepository {
    func fetchWeather(lat: Double, lon: Double) async -> Weather
}
