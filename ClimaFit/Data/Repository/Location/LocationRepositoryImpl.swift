//
//  LocationRepositoryImpl.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import Foundation
import CoreLocation

final class LocationRepositoryImpl: NSObject, LocationRepository {

    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    private var authorizationContinuation: CheckedContinuation<Void, Error>?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func getCurrentLocation() async throws -> CLLocationCoordinate2D {
        locationManager.requestWhenInUseAuthorization()
        try await waitForAuthorization()
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            locationManager.requestLocation()
        }
    }

    private func waitForAuthorization() async throws {
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            return
        }
        try await withCheckedThrowingContinuation { continuation in
            self.authorizationContinuation = continuation
        }
    }
}

extension LocationRepositoryImpl: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            authorizationContinuation?.resume()
            authorizationContinuation = nil
        case .denied, .restricted:
            authorizationContinuation?.resume(throwing: NSError(domain: "LocationAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Permiso denegado"]))
            authorizationContinuation = nil
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            locationContinuation?.resume(throwing: NSError(domain: "LocationError", code: 0, userInfo: nil))
            locationContinuation = nil
            return
        }
        locationContinuation?.resume(returning: location.coordinate)
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}
