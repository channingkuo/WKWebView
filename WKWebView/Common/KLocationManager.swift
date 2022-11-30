//
//  LocationManager.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/3/22.
//

import UIKit
import CoreLocation

class KLocationManager: NSObject {
    
    fileprivate var locationManager: CLLocationManager
    fileprivate var distanceFilter: Double?
    
    var viewController: UIViewController?
    var delegate: LocationDelegate?
    var didSendLocation: Bool = true
    
    static let sharedInstance: KLocationManager = {
        let instance = KLocationManager()
        return instance
    }()
    
    override init() {
        self.locationManager = CLLocationManager()
        
        super.init()
        
        self.locationManager.delegate = self
    }
    
    func startUpdatingLocation(distanceFilter: Double?) {
        self.distanceFilter = distanceFilter
        
        if self.locationManager.authorizationStatus == .denied {
            requestAuthorizationAlert()
        } else {
            requestAuthorization()
        }
    }
    
    func requestAuthorization() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        /// distanceFilter 定位精度，默认100米
        self.locationManager.distanceFilter = self.distanceFilter ?? 100.0
//        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func requestAuthorizationAlert() {
        let alert = UIAlertController(title: "定位服务暂未开启，是否前往设置？", message: "", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let settingButton = UIAlertAction(title: "设置", style: .default, handler: { _ in
            let url = URL(string: UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.canOpenURL(url!)
            }
        })
        alert.addAction(cancelButton)
        alert.addAction(settingButton)
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func transferLocation(_ transformLocation: Location, placemarks: [CLPlacemark]?) {
        var pois: [Poi] = []
        if placemarks != nil {
            for placemark in placemarks! {
                let poi = Poi(
                    street: placemark.thoroughfare ?? "",
                    streetNo: placemark.subThoroughfare ?? "",
                    city: placemark.locality ?? "",
                    area: placemark.subLocality ?? "",
                    province: placemark.administrativeArea ?? "",
                    postalCode: placemark.postalCode ?? "",
                    countryCode: placemark.isoCountryCode ?? "",
                    country: placemark.country ?? ""
                )
                pois.append(poi)
            }
        }
        self.delegate?.coordinateUpdated(latitude: transformLocation.latitude, longitude: transformLocation.longitude, pois: pois)
    }
}

// MARK: - CLLocationManagerDelegate
extension KLocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        let location = locations.last ?? CLLocation()
        let coordinate = location.coordinate
        
        let transformLocation = LocationUtils.transformWGSToGCJ(location: (coordinate.latitude, coordinate.longitude))
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if placemarks != nil {
                #if DEBUG
                for placemark in placemarks! {
                    print(placemark.name ?? "")
                    print(placemark.thoroughfare ?? "")
                    print(placemark.subThoroughfare ?? "")
                    print(placemark.locality ?? "")
                    print(placemark.country ?? "")
                }
                #endif
            }
            if !self.didSendLocation {
                self.transferLocation(transformLocation, placemarks: placemarks)
                self.didSendLocation = true
            }
        })
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .restricted {
            requestAuthorizationAlert()
        } else if status == .denied {
            requestAuthorizationAlert()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {

        } else if status == .notDetermined {

        }
    }
        
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}
