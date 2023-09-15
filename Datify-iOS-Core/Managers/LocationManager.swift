//
//  LocationManager.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 10.09.2023.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ location: LocationModel)
    func didFailWithError(_ error: Error)
}

struct LocationModel {
    let country: Country?
    let city: Country?
    let coordinates: CLLocationCoordinate2D
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var country: Country?
    @Published var city: Country?
    @Published var location: LocationModel?

    weak var delegate: LocationManagerDelegate?

    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.reverseGeocodeLocation(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error)
    }

    private func reverseGeocodeLocation(_ location: CLLocation) {
        let geocoder = CLGeocoder()

        let locale = Locale(identifier: "en_US")

        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            if let error = error {
                self.delegate?.didFailWithError(error)
                return
            }

            if let placemark = placemarks?.first {
                let country = placemark.country
                let city = placemark.locality
                let coordinates = location.coordinate

                self.country = Country(name: country ?? "", cities: [])
                self.city = Country(name: city ?? "", cities: [])
                let locationModel = LocationModel(country: self.country, city: self.city, coordinates: coordinates)
                self.location = locationModel
                self.delegate?.didUpdateLocation(locationModel)
            }
        }
    }

}
