//
//  LocationManager.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 10.09.2023.
//

import Combine
import CoreLocation

struct LocationModel: Equatable {
    var selectedCountryAndCity: Country?
    var selectedCoordinates: CLLocationCoordinate2D
}

class LocationManager: NSObject, ObservableObject {
    @Published var location: LocationModel?
    @Published var error: Error?

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
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                self?.error = error
                return
            }
            if let placemark = placemarks?.first {
                let countryName = placemark.country ?? ""
                let cityName = placemark.locality ?? ""
                let coordinates = location.coordinate

                let selectedCountry = Country(name: countryName, cities: [cityName], selectedCity: cityName)

                let locationModel = LocationModel(
                    selectedCountryAndCity: selectedCountry,
//                    selectedCity: cityName,
                    selectedCoordinates: coordinates
                )
                self?.location = locationModel
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            reverseGeocodeLocation(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError, clError.code == .locationUnknown {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                self.requestLocation()
            }
        }
        self.error = error
    }
}

extension LocationModel {
    static func == (lhs: LocationModel, rhs: LocationModel) -> Bool {
        return lhs.selectedCountryAndCity == rhs.selectedCountryAndCity
    }
}
