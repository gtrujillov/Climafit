import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var weather: Weather?
    @Published var isLoading = false
    @Published var error: String?
    
    private let weatherAPI: WeatherAPIProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(weatherAPI: WeatherAPIProtocol) {
        self.weatherAPI = weatherAPI
    }
    
    func fetchWeather(for location: CLLocation) {
        isLoading = true
        error = nil
        
        weatherAPI.fetchWeather(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] weather in
            self?.weather = weather
            self?.error = nil
        }
        .store(in: &cancellables)
    }
} 