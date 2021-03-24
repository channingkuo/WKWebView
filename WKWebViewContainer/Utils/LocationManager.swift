//
//  LocationManager.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/3/22.
//

import CoreLocation

class LocationManager: NSObject {
    
    static let sharedInstance: LocationManager = {
        let instance = LocationManager()
        // setup code
        return instance
        
    }()
    var locationManager: CLLocationManager?
}
