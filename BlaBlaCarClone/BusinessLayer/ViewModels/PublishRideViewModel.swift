//
//  PublishRideViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 01/06/23.
//

import Foundation
import MapKit
import Combine

class PublishRideViewModel: ObservableObject {
    
//    @Published var navigate = false
    @Published var isSearchPresented = false
    @Published var destSearchPresented = false
    @Published var isSeatsPresented = false
    
    @Published var date = Date.now
    @Published var noOfSeats: Int = 1
    @Published var startlocation = String()
    @Published var destination = String()
    @Published var myDate = String()
    @Published var price = String()
    @Published var vehicle: Vehicle?
    
    @Published var pathString = String()
    @Published var region = MKCoordinateRegion()
    
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
    
    var publisher: AnyCancellable?
    let network = NetworkManager.shared
    
    var startCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var destCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    func showButton() -> Bool {
        if !startlocation.isEmpty && !destination.isEmpty && !price.isEmpty && vehicle != nil {
            return true
        }
        return false
    }
    
    func getPathString(originLat: String, originLon: String, destLat: String, destLon: String) {
        
        publisher = network.getRoute(originLat: originLat, originLon: originLon, destLat: destLat, destLon: destLon)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoading = false
                    self.hasError = true
                    self.errorMessage = error as? APIError
                    
                case .finished:
                    print("done")
                    self.isLoading = false
                    self.hasError = false
                    self.isSuccess.toggle()
                }
            } receiveValue: { [weak self] data in
                self?.pathString = data
            }
    }
}
