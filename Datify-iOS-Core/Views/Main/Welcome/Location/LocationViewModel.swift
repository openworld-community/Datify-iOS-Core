//
//  LocationViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 10.09.2023.
//

import Combine
import Foundation

final class LocationViewModel: ObservableObject {
    @Published var selectedCountry: Country?
    @Published var selectedCity: Country?
    @Published var location: LocationModel?

    var locationManager = LocationManager()

    private weak var router: Router<AppRoute>?
    private var cancellables = Set<AnyCancellable>()

    init(
        router: Router<AppRoute>,
        locationManager: LocationManager = LocationManager()
    ) {
        self.router = router
        self.locationManager = locationManager
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }
}

extension LocationViewModel: LocationManagerDelegate {
    func didUpdateLocation(_ location: LocationModel) {
        DispatchQueue.main.async { // Обновляем UI в главном потоке
            self.location = location
            self.selectedCountry = location.country
            self.selectedCity = location.city
        }
    }

    func didFailWithError(_ error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
}
