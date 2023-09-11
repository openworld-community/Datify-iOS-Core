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
    let country: String?
    let city: String?
    let coordinates: CLLocationCoordinate2D
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    @Published var country: String?
    @Published var city: String?

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
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    self.delegate?.didFailWithError(error)
                    return
                }

                if let placemark = placemarks?.first {
                    let country = placemark.country
                    let city = placemark.locality
                    let coordinates = location.coordinate
                    let locationModel = LocationModel(country: country, city: city, coordinates: coordinates)
                    self.delegate?.didUpdateLocation(locationModel)
                }
            }
        }
}
