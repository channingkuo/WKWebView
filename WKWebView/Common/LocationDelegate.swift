//
//  LocationDelegate.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/4/28.
//

import Foundation
import CoreLocation

protocol LocationDelegate: AnyObject {
    
    func coordinateUpdated(latitude: Double, longitude: Double, pois: [Poi])
}

struct Poi: Codable {
    var street: String
    var streetNo: String
    var city: String
    var area: String
    var province: String
    var postalCode: String
    var countryCode: String
    var country: String
}

struct LocationBridge: Codable {
    var latitude: Double
    var longitude: Double
    var pois: [Poi]
}
