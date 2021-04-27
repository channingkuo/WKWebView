//
//  LocationManager.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/3/22.
//

import UIKit
import CoreLocation

@objc protocol LocationProtocol {
    
    func coordinateUpdated(latitude: Double, longitude: Double, placemarks: [CLPlacemark]?)
}

class LocationManager: NSObject {
    
    static let sharedInstance: LocationManager = {
        let instance = LocationManager()
        
        return instance
    }()
    
    fileprivate var locationManager: CLLocationManager?
    fileprivate var viewController: UIViewController?
    fileprivate var distanceFilter: Double?
    
    weak var delegate: LocationProtocol?
    
    /// distanceFilter 定位精度，默认100米
    func startUpdatingLocation(_ viewCtrl: UIViewController, distanceFilter: Double?) {
        viewController = viewCtrl
        self.distanceFilter = distanceFilter
//        delegate = viewCtrl as? LocationProtocol
        
        if locationManager != nil && CLLocationManager.authorizationStatus() == .denied {
            requestAuthorizationAlert(viewCtrl)
        } else {
            requestAuthorization()
        }
    }
    
    fileprivate func requestAuthorization() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        }
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = distanceFilter ?? 100.0
            locationManager?.startUpdatingLocation()
        }
    }
    
    fileprivate func requestAuthorizationAlert(_ viewCtrl: UIViewController) {
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
        viewCtrl.present(alert, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        
        let location = locations.last ?? CLLocation()
        let coordinate = location.coordinate
        
        let transformLocation = LocationUtils.transformWGSToGCJ(location: (coordinate.latitude, coordinate.longitude))
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            #if DEBUG
            print(error as Any)
            #endif
            if placemarks != nil {
                self.delegate?.coordinateUpdated(latitude: transformLocation.latitude, longitude: transformLocation.longitude, placemarks: placemarks)
                #if DEBUG
                for placemark in placemarks! {
                    print(placemark.name ?? "")
                    print(placemark.thoroughfare ?? "")
                    print(placemark.subThoroughfare ?? "")
                    print(placemark.locality ?? "")
                    print(placemark.country ?? "")
                }
                #endif
            } else {
                self.delegate?.coordinateUpdated(latitude: transformLocation.latitude, longitude: transformLocation.longitude, placemarks: nil)
            }
        })
    }
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            requestAuthorization()
        } else if status == .restricted {
            requestAuthorizationAlert(viewController!)
        } else if status == .denied {
            requestAuthorizationAlert(viewController!)
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
    }
}
