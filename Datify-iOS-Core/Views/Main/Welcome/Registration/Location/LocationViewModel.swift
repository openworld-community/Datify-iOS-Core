//
//  LocationViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 10.09.2023.
//

import Combine
import Foundation

final class LocationViewModel: ObservableObject {
    @Published var country: String?
    @Published var city: String?

    private var locationManager = LocationManager()
    private weak var router: Router<AppRoute>?
    private var cancellables = Set<AnyCancellable>()

    init(router: Router<AppRoute>?) {
        self.router = router
        setupLocationManager()

        locationManager.$country
            .assign(to: \.country, on: self)
            .store(in: &cancellables)

        locationManager.$city
            .assign(to: \.city, on: self)
            .store(in: &cancellables)
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }
}

 extension LocationViewModel: LocationManagerDelegate {
     func didUpdateLocation(_ location: LocationModel) {
         self.country = location.country
         self.city = location.city
     }

     func didFailWithError(_ error: Error) {
         print("Error getting location: \(error.localizedDescription)")
     }
 }
