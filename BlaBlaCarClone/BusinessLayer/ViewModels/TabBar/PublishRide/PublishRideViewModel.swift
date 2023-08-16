//
//  PublishRideViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 01/06/23.
//

import Foundation
import CoreLocation
import Combine

class PublishRideViewModel: ObservableObject {

    @Published var isSearchPresented = false
    @Published var destSearchPresented = false
    @Published var isSeatsPresented = false
    @Published var rootViewId = UUID()
    
    @Published var dismiss = false
    
    @Published var startlocation = String()
    @Published var destination = String()
    @Published var startCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var destCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var noOfSeats: Int = 1
    @Published var date = Date.now
    @Published var price = Int()
    @Published var vehicle: Vehicle?
    @Published var selectRoute: DirectionsResponse?
    @Published var aboutRide = String()
    
    @Published var rideResponse = PublishRideResponse.publishRideResponse
    
    @Published var pathString = String()
    @Published var totalDistance = String()
    @Published var estimatedTime = String()
    @Published var timeValue = Int()
    @Published var distance: Int?
    
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
    @Published var navigate = false
    @Published var isPresented = false
    
    var publisher: AnyCancellable?
    var cancellable: AnyCancellable?
    let network = NetworkManager.shared
    
    func showButton() -> Bool {
        if !startlocation.isEmpty && !destination.isEmpty && vehicle != nil {
            return true
        }
        return false
    }
    
    /// To get pathString to show polyline for route in map
    /// - Parameters:
    ///   - originLat: source latitude
    ///   - originLon: source longitude
    ///   - destLat: destination latitude
    ///   - destLon: destination longitude
    func getPathString() {
        
        self.isLoading = true

        publisher = network.getRoute(originLat: String(startCoordinates.latitude),
                                     originLon: String(startCoordinates.longitude),
                                     destLat: String(destCoordinates.latitude),
                                     destLon: String(destCoordinates.longitude))
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
                self?.selectRoute = data
                if let routes = data.routes {
                    if !routes.isEmpty {
                        self?.pathString = routes[0].overviewPolyline.points
                        if !routes[0].legs.isEmpty {
                            self?.totalDistance = routes[0].legs[0].distance.text
                            self?.distance = routes[0].legs[0].distance.value
                            self?.estimatedTime = routes[0].legs[0].duration.text
                            self?.timeValue = routes[0].legs[0].duration.value ?? 0
                        }
                    }
                }
            }
    }
    
    func publishRide() {
        
        self.isLoading = true
        
        guard let data = makeCredentials() else {
            return
        }
        cancellable = network.publishRide(data: data)
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
                    self.navigate.toggle()
                }
            } receiveValue: { [weak self] data in
                self?.rideResponse = data
            }
    }
    
    func makeCredentials() -> PublishRideData? {
        
        guard let id = vehicle?.id else {
            return nil
        }
        let time = secondsToHoursMinutesSeconds(timeValue)
        return PublishRideData(publish: Publish(
            source: startlocation,
            destination: destination,
            sourceLongitude: startCoordinates.longitude,
            sourceLatitude: startCoordinates.latitude,
            destinationLongitude: destCoordinates.longitude,
            destinationLatitude: destCoordinates.latitude,
            passengersCount: noOfSeats,
            addCity: nil,
            addCityLongitude: nil,
            addCityLatitude: nil,
            date: DateFormatterUtil.shared.formatDate(date: date),
            time: self.date.formatted(date: .omitted, time: .shortened),
            setPrice: Double(price),
            aboutRide: aboutRide,
            vehicleID: id,
            bookInstantly: nil,
            midSeat: nil,
            estimateTime: "\(time.0):\(time.1):\(time.2)",
            selectRoute: selectRoute))
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func reset() {
        if dismiss {
            startlocation = String()
            destination = String()
            date = Date()
            vehicle = nil
            noOfSeats = 1
//            price = String()
        }
        dismiss = false
    }
    
    func getPrice() {
        if let distance {
            let price = Double(distance/1000).rounded() * 3.0
            self.price = Int((price/10).rounded() * 10)
            isPresented = true
        } else {
            isPresented = false
        }
    }
}
