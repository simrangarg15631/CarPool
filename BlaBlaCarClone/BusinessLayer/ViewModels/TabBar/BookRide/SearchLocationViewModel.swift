//
//  SearchViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 16/05/23.
//

import Foundation
import MapKit
import Combine

class SearchLocationViewModel: NSObject, ObservableObject {
    
    // MARK: Properties
    var publisher: AnyCancellable?
    let locationManager = CLLocationManager()
    
    @Published var searchText = String()
    @Published var searchResults: [CLPlacemark]?
    @Published var location: CLLocation?
    
    override init() {
        
        //        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        publisher = $searchText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink(receiveValue: { value in
                if !value.isEmpty {
                    self.getPlace(from: value)
                } else {
                    self.searchResults = nil
                }
            })
    }
    
    // MARK: - Method
    
    func getPlace(from address: String) {
        Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = address.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                
                DispatchQueue.main.async {
                    self.searchResults = response.mapItems.compactMap({ item -> CLPlacemark? in
                        return item.placemark
                    })
                }
            } catch {
//                print("error searching")
            }
        }
    }
}

extension SearchLocationViewModel: CLLocationManagerDelegate {
    
    /// calling this method will trigger a prompt to request "when-in-use" authorization from the user.
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        self.location = currentLocation
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        checkLocationAuthorization()
        //        authorizationStatus = manager.authorizationStatus
    }
    
    private func checkLocationAuthorization() {
        // guard let locationManager = locationManager else {return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("Go to settings to change request")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
}
