//
//  QiblaManager.swift
//  QuranApp
//
//  Created by abbas on 04/05/2025.
//

import Foundation
import CoreLocation
import SwiftUI

class QiblaManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    @Published var qiblaDirection: Double = 0.0
    @Published var userHeading: Double = 0.0

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.headingAvailable() {
            locationManager.startUpdatingHeading()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        userHeading = newHeading.trueHeading

        // Coordonnées de la Kaaba
        let kaabaLatitude = 21.4225
        let kaabaLongitude = 39.8262

        if let location = manager.location {
            let userLatitude = location.coordinate.latitude
            let userLongitude = location.coordinate.longitude

            let deltaLong = kaabaLongitude - userLongitude

            let y = sin(deltaLong * .pi / 180) * cos(kaabaLatitude * .pi / 180)
            let x = cos(userLatitude * .pi / 180) * sin(kaabaLatitude * .pi / 180) -
                    sin(userLatitude * .pi / 180) * cos(kaabaLatitude * .pi / 180) * cos(deltaLong * .pi / 180)

            let bearing = atan2(y, x) * 180 / .pi
            qiblaDirection = (bearing + 360).truncatingRemainder(dividingBy: 360)
        }
    }
}
