//
//  LocationUtils.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/4/9.
//

import Foundation

typealias Location = (latitude: Double, longitude: Double)
typealias Latitude = Double
typealias Longitude = Double

class LocationUtils {
    
    static func transformGCJToWGS(location: Location) -> Location {
        let gcjLocation       : Location = location
        var wgsLocation       : Location = location
        var currentGcjLocation: Location = (0, 0)
        var dLocation         : Location = (0, 0)
        
        while true {
            currentGcjLocation = transformWGSToGCJ(location: location)
            
            dLocation.latitude  = gcjLocation.latitude - currentGcjLocation.latitude
            dLocation.longitude = gcjLocation.longitude - currentGcjLocation.longitude
            
            if fabs(dLocation.latitude) < 1e-7 && fabs(dLocation.longitude) < 1e-7 {
                return wgsLocation
            }
            
            wgsLocation.latitude  = dLocation.latitude
            wgsLocation.longitude = dLocation.longitude
        }
        return wgsLocation
    }
    
    static func transformWGSToGCJ(location: Location) -> Location {
        if inChinaRange(location: location) {
            return location
        }
        var dLatitude  = transformLatitude(location: (location.latitude - 105.0, location.longitude - 35.0))
        var dLongitude = transformLongitude(location: (location.latitude - 105.0, location.longitude - 35.0))
        
        let radLatitude = dLatitude / 180.0 * Double.pi
        var magic = sin(radLatitude)
        magic = 1 - 0.00669342162296594323 * pow(magic, 2)
        let sqrtMagic = sqrt(magic)
        dLatitude  = dLatitude * 180.0 / ((6378245.0 * (1 - 0.00669342162296594323)) / (magic * sqrtMagic) * Double.pi)
        dLongitude = dLongitude * 180.0 / (6378245.0 / sqrtMagic * cos(radLatitude) * Double.pi)
        
        return (location.latitude + dLatitude, location.longitude + dLongitude)
    }
    
    static func transformGCJToBD(location: Location) -> Location {
        return (location.latitude + 0.006, location.longitude + 0.006)
    }
    
    static func transformBDToGCJ(location: Location) -> Location {
        return (location.latitude - 0.006, location.longitude - 0.006)
    }
    
    fileprivate static func transformLatitude(location: Location) -> Latitude {
        var latitude = -100 + 2.0 * location.latitude + 3.0 * location.longitude + 0.2 * pow(location.longitude, 2) + 0.1 * location.latitude * location.longitude + 0.2 * sqrt(fabs(location.latitude))
        latitude += (20.0 * sin(6.0 * location.latitude * Double.pi) + 20.0 * sin(2.0 * location.latitude * Double.pi)) * 2.0 / 3.0
        latitude += (20.0 * sin(location.longitude * Double.pi) + 40.0 * sin(location.longitude / 3.0 * Double.pi)) * 2.0 / 3.0
        latitude += (160.0 * sin(location.longitude / 12.0 * Double.pi) + 320.0 * sin(location.longitude * Double.pi / 30.0)) * 2.0 / 3.0
        
        return latitude
    }
    
    fileprivate static func transformLongitude(location: Location) -> Longitude {
        var longitude = 300 + location.latitude + 2.0 * location.longitude + 0.1 * pow(location.latitude, 2) + 0.1 * location.latitude * location.longitude + 0.1 * sqrt(fabs(location.latitude))
        longitude += (20.0 * sin(6.0 * location.latitude * Double.pi) + 20.0 * sin(2.0 * location.latitude * Double.pi)) * 2.0 / 3.0
        longitude += (20.0 * sin(location.latitude * Double.pi) + 40.0 * sin(location.latitude / 3.0 * Double.pi)) * 2.0 / 3.0
        longitude += (150.0 * sin(location.latitude / 12.0 * Double.pi) + 300.0 * sin(location.latitude * Double.pi / 30.0)) * 2.0 / 3.0
        
        return longitude
    }
    
    fileprivate static func inChinaRange(location: Location) -> Bool {
        if location.longitude < 72.004 || location.longitude > 137.8347 {
            return true
        }
        if location.latitude < 0.8293 || location.latitude > 55.8271 {
            return true
        }
        return false
    }
}
