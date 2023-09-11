//
//  LocationViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 10.09.2023.
//

import Combine
import Foundation

final class LocationViewModel: ObservableObject {
    @Published var country: String = .init()
    @Published var city: String = .init()

    private var locationManager = LocationManager()
    private weak var router: Router<AppRoute>?
    private var cancellables = Set<AnyCancellable>()

    init(router: Router<AppRoute>?) {
        self.router = router
        setupLocationManager()

        locationManager.$country
            .sink { [weak self] updatedCountry in
                self?.country = updatedCountry ?? "Serbia"
            }
            .store(in: &cancellables)

        locationManager.$city
            .sink { [weak self] updatedCity in
                self?.city = updatedCity ?? "Belgrade"
            }
            .store(in: &cancellables)
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }
}

 extension LocationViewModel: LocationManagerDelegate {
     func didUpdateLocation(_ location: LocationModel) {
         self.country = location.country ?? "Serbian"
         self.city = location.city ?? "Belgrade"
     }

     func didFailWithError(_ error: Error) {
         print("Error getting location: \(error.localizedDescription)")
     }
 }
