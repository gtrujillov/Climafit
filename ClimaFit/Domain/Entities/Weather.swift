import Foundation

struct Weather: Identifiable {
    let id = UUID()
    let temperature: Double
    let humidity: Int
    let windSpeed: Double
    let description: String
    let icon: String
    
    var temperatureFormatted: String {
        return "\(Int(round(temperature)))°C"
    }
    
    var windSpeedFormatted: String {
        return "\(Int(round(windSpeed))) km/h"
    }
    
    var humidityFormatted: String {
        return "\(humidity)%"
    }
} 