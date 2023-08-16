//
//  EditPublicationViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 08/06/23.
//

import Foundation
import Combine
import CoreLocation

class EditPublicationViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var isSuccess = false
    @Published var hasError = false
    @Published var errorMessage: APIError?
    
    @Published var success = false
    @Published var anyError = false

    @Published var date = Date()
    @Published var time = Date()
    @Published var source = String()
    @Published var destination = String()
    
    @Published var sourceCoord = CLLocationCoordinate2D()
    @Published var destCoord = CLLocationCoordinate2D()
    
    @Published var price = Int()
    @Published var seats = Int()
    @Published var aboutRide = String()
    
    @Published var srcPresent = false
    @Published var destPresent = false
    
    @Published var response: Status = Status(code: 200)
    @Published var rideData: PublishDetails = PublishRideResponse.publishRideResponse.publish
    var publisher: AnyCancellable?
    let network = NetworkManager.shared
    
    func cancelPublish(id: Int) {
        isLoading = true
        
        publisher = network.cancelPublish(data: CancelBookingModel(id: id))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    
                case .failure(let error):
                    self?.isLoading = false
                    self?.hasError = true
                    self?.errorMessage = error as? APIError
                    
                case .finished:
                    self?.isLoading = false
                    self?.isSuccess = true
                }
            }, receiveValue: { [weak self] data in
                self?.response = data
            })
    }
    
    func editPublication(id: Int) {
        isLoading = true
        
        let data = UpdateData(
            source: source,
            destination: destination,
            sourceLongitude: sourceCoord.longitude,
            sourceLatitude: sourceCoord.latitude,
            destinationLongitude: destCoord.longitude,
            destinationLatitude: destCoord.latitude,
            passengersCount: seats,
            date: DateFormatterUtil.shared.formatDate(date: date),
            time: DateFormatterUtil.shared.formatDate(date: time, format: DateTimeFormat.hourMin),
            setPrice: Double(price),
            aboutRide: aboutRide)
        
        publisher = network.updatePublishedRide(publishId: id, data: UpdateRideData(publish: data))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    
                case .failure(let error):
                    self?.isLoading = false
                    self?.anyError = true
                    self?.success = false
                    self?.errorMessage = error as? APIError
                    
                case .finished:
                    self?.isLoading = false
                    self?.anyError = false
                    self?.success = true
                }
            }, receiveValue: { [weak self] data in
                self?.rideData = data.publish
            })
    }
}
