//
//  LocationViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 10.09.2023.
//

import Combine
import Foundation

final class LocationViewModel: ObservableObject {
    @Published var location: LocationModel?
    @Published var error: Error?
    @Published var isLoading: Bool = false

    var locationManager = LocationManager()

    private weak var router: Router<AppRoute>?
    private var cancellables = Set<AnyCancellable>()

    init(
        router: Router<AppRoute>
    ) {
        self.router = router
        setupLocationManager()
        setupSubscribers()
    }

    func setupLocationManager() {
        self.isLoading = true
        locationManager.requestLocation()
    }
    private func setupSubscribers() {
        locationManager.$location
            .sink { [weak self] newLocation in
                self?.location = newLocation
            }
            .store(in: &cancellables)

        locationManager.$error
            .sink { [weak self] newError in
                self?.error = newError
            }
            .store(in: &cancellables)
    }

    func selectCountry(_ country: Country) {
        location?.selectedCountry = country
        location?.selectedCountry?.selectedCity = country.cities.first
    }

    func selectCity(_ city: String) {
        location?.selectedCountry?.selectedCity = city
    }
}
