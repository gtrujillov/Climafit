import SwiftUI
import CoreLocation

struct WeatherDetailView: View {
    @StateObject private var viewModel: WeatherViewModel
    let initialLocation: CLLocation
    
    @State private var placeName: String = ""
    @State private var placeSearchText: String = ""
    
    init(
        location: CLLocation
    ) {
        self.initialLocation = location
        let weatherAPI = WeatherAPI(apiKey: Config.openWeatherAPIKey)
        let searchUseCase = DefaultSearchCityUseCase()
        _viewModel = StateObject(wrappedValue: WeatherViewModel(weatherAPI: weatherAPI, searchCityUseCase: searchUseCase))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Show place name if available
                    if let weather = viewModel.weather {
                        if !placeName.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Ubicación")
                                    .font(AppTheme.carosSoftFont(.light, size: 16))
                                    .foregroundColor(.primary)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                Text(placeName)
                                    .font(AppTheme.carosSoftFont(.bold, size: 16))
                                    .foregroundColor(.primary)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        VStack(spacing: 10) {
                            HStack(spacing: 20) {
                                Text(weather.temperatureFormatted)
                                    .font(AppTheme.carosSoftFont(.bold, size: 54))
                                    .foregroundColor(AppTheme.prussianBlue)
                                Image(systemName: "sun.max.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(AppTheme.prussianBlue)
                                    .shadow(radius: 2)
                            }
                            Text(weather.description.capitalized)
                                .font(AppTheme.carosSoftFont(.regular, size: 14))
                                .foregroundColor(.secondary)
                            HStack(spacing: 24) {
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
                            .padding(10)
                            .background(AppTheme.cardBackground)
                            .cornerRadius(AppTheme.cornerRadius)
                            .shadow(color: AppTheme.shadow, radius: 12, x: 0, y: 6)
                            .frame(maxWidth: .infinity)
                        }
                        
                        // Search bar always visible
                        SearchBarView(searchText: $placeSearchText)
                            .onSubmit {
                                viewModel.performSearch()
                            }
                        
                        ClothingRecommendationView(temperature: weather.temperature)
                            .animation(.easeInOut, value: weather.temperature)
                    }
                }
                .padding()
            }
            .onAppear {
                viewModel.fetchWeather(for: initialLocation)
                fetchPlaceName(for: initialLocation)
            }
        }
    }
    
    func fetchPlaceName(for location: CLLocation) {
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
