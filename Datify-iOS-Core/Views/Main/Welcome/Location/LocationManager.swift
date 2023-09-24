//
//  LocationManager.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 10.09.2023.
//

import Combine
import CoreLocation

struct LocationModel: Equatable {
    var selectedCountry: Country?
    var selectedCoordinates: CLLocationCoordinate2D
}

class LocationManager: NSObject, ObservableObject {
    @Published var location: LocationModel?
    @Published var error: Error?
    @Published var isLoading: Bool = false

    private var locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }

    private func reverseGeocodeLocation(_ location: CLLocation) {
        Task {
            do {
                let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
                if let placemark = placemarks.first {
                    let countryName = placemark.country ?? ""
                    let cityName = placemark.locality ?? ""
                    let coordinates = location.coordinate

                    let selectedCountry = Country(name: countryName, cities: [cityName], selectedCity: cityName)

                    await MainActor.run {
                        self.location = LocationModel(
                            selectedCountry: selectedCountry,
                            selectedCoordinates: coordinates
                        )
                    }
                }
            } catch {
                // TODO: Handle error
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }

}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            reverseGeocodeLocation(location)

            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError, clError.code == .locationUnknown {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                self.requestLocation()
            }
        }

        DispatchQueue.main.async {
            self.isLoading = false
        }

        self.error = error
    }
}

extension LocationModel {
    static func == (lhs: LocationModel, rhs: LocationModel) -> Bool {
        return lhs.selectedCountry == rhs.selectedCountry
    }
}
