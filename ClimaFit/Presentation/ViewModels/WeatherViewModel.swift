import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    // MARK: - Published properties
    @Published var weather: Weather?
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchText: String = ""
    
    // MARK: - Dependencies
    private let weatherAPI: WeatherAPIProtocol
    private let searchCityUseCase: SearchCityUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        weatherAPI: WeatherAPIProtocol,
        searchCityUseCase: SearchCityUseCase
    ) {
        self.weatherAPI = weatherAPI
        self.searchCityUseCase = searchCityUseCase
    }
    
    // MARK: - Public methods
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
    
    func performSearch() {
        guard !searchText.isEmpty else { return }
        isLoading = true
        error = nil
        
        Task {
            do {
                let location = try await searchCityUseCase.execute(city: searchText)
                await MainActor.run {
                    self.fetchWeather(for: location)
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.error = "No se pudo encontrar la ciudad."
                }
            }
        }
    }
}
