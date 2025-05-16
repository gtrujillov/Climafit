import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                Group {
                    switch locationManager.authorizationStatus {
                    case .notDetermined:
                        WelcomeView()
                            .environmentObject(locationManager)
                    case .restricted, .denied:
                        LocationDeniedView()
                            .environmentObject(locationManager)
                    case .authorizedWhenInUse, .authorizedAlways:
                        if let location = locationManager.location {
                            WeatherDetailView(location: location)
                        } else {
                            ProgressView("Obteniendo ubicación...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        }
                    @unknown default:
                        Text("Estado desconocido")
                    }
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    
    override init() {
        authorizationStatus = manager.authorizationStatus
        
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestPermission() {
        print("Estado actual: \(authorizationStatus.rawValue)")
        if authorizationStatus == .notDetermined {
            print("Solicitando permiso de ubicación...")
            manager.requestWhenInUseAuthorization()
        } else if authorizationStatus == .denied {
            print("Permiso denegado previamente. Sugiere abrir Ajustes.")
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Nuevo estado de autorización: \(manager.authorizationStatus.rawValue)")
        authorizationStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación: \(error.localizedDescription)")
    }
} 