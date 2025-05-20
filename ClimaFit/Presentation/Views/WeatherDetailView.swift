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
                            VStack(spacing: 16) {
                                HStack {
                                    Text(weather.temperatureFormatted)
                                        .font(.system(size: 64, weight: .bold))
                                        .foregroundColor(AppTheme.accent)
                                        .transition(.scale)
                                    Image(systemName: "cloud.sun.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(AppTheme.accent)
                                        .shadow(radius: 4)
                                        .padding(.bottom, 8)
                                }
                                Text(weather.description.capitalized)
                                    .font(AppTheme.subtitleFont)
                                    .foregroundColor(.primary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .animation(.spring(), value: weather.temperatureFormatted)

                            HStack {
                                Spacer()
                                WeatherDetailItem(
                                    icon: "humidity.fill",
                                    value: weather.humidityFormatted,
                                    title: "Humedad"
                                )
                                Spacer()
                                WeatherDetailItem(
                                    icon: "wind",
                                    value: weather.windSpeedFormatted,
                                    title: "Viento"
                                )
                                Spacer()
                            }
                            .padding(24)
                            .background(AppTheme.cardBackground)
                            .cornerRadius(AppTheme.cornerRadius)
                            .shadow(color: AppTheme.shadow, radius: 12, x: 0, y: 6)
                            .frame(maxWidth: .infinity)
                            .animation(.easeInOut, value: weather.humidityFormatted)
                            ClothingRecommendationView(temperature: weather.temperature)
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


extension Weather {
    static let mock = Weather(
        temperature: 22.0,
        humidity: 14,
        windSpeed: 55,
        description: "Soleado",
        icon: "sun.max.fill"
    )
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(location: CLLocation(latitude: 37.7749, longitude: -122.4194))
    }
}
