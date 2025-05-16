import SwiftUI
import CoreLocation

struct WeatherDetailView: View {
    @StateObject private var viewModel: WeatherViewModel
    let location: CLLocation
    @State private var placeName: String = ""
    
    init(location: CLLocation) {
        self.location = location
        let weatherAPI = WeatherAPI(apiKey: Config.openWeatherAPIKey)
        _viewModel = StateObject(wrappedValue: WeatherViewModel(weatherAPI: weatherAPI))
    }
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 32) {
                    if !placeName.isEmpty {
                        Text(placeName)
                            .font(AppTheme.subtitleFont)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 24)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.accent))
                            .padding(.vertical, 80)
                    } else if let error = viewModel.error {
                        ErrorView(message: error) {
                            viewModel.fetchWeather(for: location)
                        }
                        .padding(.vertical, 40)
                        .transition(.opacity)
                    } else if let weather = viewModel.weather {
                        VStack(spacing: 28) {
                            ModernCard {
                                VStack(spacing: 16) {
                                    Image(systemName: "cloud.sun.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(AppTheme.accent)
                                        .shadow(radius: 4)
                                        .padding(.bottom, 8)
                                    Text(weather.temperatureFormatted)
                                        .font(.system(size: 64, weight: .bold))
                                        .foregroundColor(AppTheme.accent)
                                        .transition(.scale)
                                    Text(weather.description.capitalized)
                                        .font(AppTheme.subtitleFont)
                                        .foregroundColor(.primary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                            }
                            .frame(maxWidth: .infinity)
                            .animation(.spring(), value: weather.temperatureFormatted)
                            ModernCard {
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
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                            }
                            .frame(maxWidth: .infinity)
                            .animation(.easeInOut, value: weather.humidityFormatted)
                            ModernCard {
                                ClothingRecommendationView(temperature: weather.temperature)
                            }
                            .frame(maxWidth: .infinity)
                            .animation(.easeInOut, value: weather.temperature)
                        }
                        .frame(maxWidth: 500)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .animation(.easeInOut, value: viewModel.weather?.temperatureFormatted)
            }
        }
        .onAppear {
            viewModel.fetchWeather(for: location)
            fetchPlaceName(for: location)
        }
    }
    
    private func fetchPlaceName(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let city = placemarks?.first?.locality {
                placeName = city
            } else if let name = placemarks?.first?.name {
                placeName = name
            } else {
                placeName = "Ubicación desconocida"
            }
        }
    }
}

struct WeatherContentView: View {
    let weather: Weather
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ModernCard {
                    VStack(spacing: 10) {
                        Text(weather.temperatureFormatted)
                            .font(.system(size: 70, weight: .bold))
                            .foregroundColor(AppTheme.accent)
                        Text(weather.description.capitalized)
                            .font(AppTheme.subtitleFont)
                            .foregroundColor(.primary)
                    }
                }
                .frame(maxWidth: .infinity)
                ModernCard {
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
                }
                .frame(maxWidth: .infinity)
                ModernCard {
                    ClothingRecommendationView(temperature: weather.temperature)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 0)
        }
    }
}

struct WeatherDetailItem: View {
    let icon: String
    let value: String
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(AppTheme.accent)
            Text(value)
                .font(.title3)
                .bold()
                .foregroundColor(.primary)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        ModernCard {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                Text("¡Ups!")
                    .font(AppTheme.subtitleFont)
                Text(message)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                PillButton(title: "Reintentar", action: retryAction)
            }
        }
    }
} 