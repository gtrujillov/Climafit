//
//  WeatherContentView.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 20/5/25.
//

import SwiftUI
import CoreLocation

struct WeatherContentView: View {
    let weather: Weather
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 10) {
                    Text(weather.temperatureFormatted)
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(AppTheme.prussianBlue)
                    Text(weather.description.capitalized)
                        .font(AppTheme.subtitleFont)
                        .foregroundColor(AppTheme.indigoDye3)
                }
                .padding()
                HStack(spacing: 40) {
                    WeatherDetailItem(
                        icon: "humidity.fill",
                        value: weather.humidityFormatted,
                        title: "Humedad"
                    )
                    WeatherDetailItem(
                        icon: "wind",
                        value: weather.windSpeedFormatted,
                        title: "Viento"
                    )
                }
                .padding()
                ClothingRecommendationView(temperature: weather.temperature)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 0)
        }
    }
}
