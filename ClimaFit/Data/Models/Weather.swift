//
//  Weather.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import Foundation

struct Weather: Identifiable {
    let id = UUID()
    let temperature: Double
    let humidity: Int
    let windSpeed: Double
    let description: String
    let icon: String
    let name: String
    
    var temperatureFormatted: String {
        return "\(Int(round(temperature)))°C"
    }
    
    var windSpeedFormatted: String {
        return "\(Int(round(windSpeed))) km/h"
    }
    
    var humidityFormatted: String {
        return "\(humidity)%"
    }
    
    var iconURL: URL {
        URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") ?? URL(string: "")!
    }
}
