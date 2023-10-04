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
    @Published var locationSetByGeo: Bool = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isCountrySelection: Bool = true
    @Published var selectedLocation: String?

    var locationManager = LocationManager()

    unowned let router: Router<AppRoute>

    private var cancellables = Set<AnyCancellable>()

    private var locationPublisher: AnyPublisher<LocationModel?, Never> {
        $location
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    init(
        router: Router<AppRoute>
    ) {
        self.router = router
        setupLocationManager()
        setupSubscribers()
        if !locationSetByGeo {
            locationManager.requestLocation()
        }
    }

    func setupLocationManager() {
        locationManager.isLoading = true
        locationManager.requestLocation()
    }
    private func setupSubscribers() {
        locationManager.$location
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLocation in
                self?.location = newLocation
            }
            .store(in: &cancellables)

        locationManager.$error
            .receive(on: DispatchQueue.main)
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

    private func handleLocationChange(_ newLocation: LocationModel?) {
        if !locationManager.isLoading, !locationSetByGeo {
            if let countryName = newLocation?.selectedCountry,
               let cityName = newLocation?.selectedCountry?.selectedCity {
                selectCountry(countryName)
                selectCity(cityName)
                locationSetByGeo = true
            }
        }
    }

    func showErrorAlert(message: String) {
        alertMessage = message
        showAlert = true
    }

    func chooseCountryAndCity() {
        router.push(.countryAndCity)
    }
}
