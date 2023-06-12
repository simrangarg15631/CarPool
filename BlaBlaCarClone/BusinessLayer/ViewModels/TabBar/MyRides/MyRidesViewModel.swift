//
//  MyRidesViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 07/06/23.

import Foundation
import Combine

class MyRidesViewModel: ObservableObject {
    
    @Published var errorMessage: APIError?
    @Published var hasError = false
    @Published var isLoading = false
    @Published var bookedRides: [Rides] = BookedRides.rides.rides
    @Published var publishedRides: [PublishDetails] = [PublishRideResponse.publishRideResponse.publish]
    @Published var selected = AppConstants.AppStrings.booked
    @Published var isSuccess = false
    @Published var success = false
    @Published var isActive = true
    
    var array = [AppConstants.AppStrings.booked, AppConstants.AppStrings.published]
    let network = NetworkManager.shared
    var publisher: AnyCancellable?
    var cancellable: AnyCancellable?
    
    func getAllBookedRides() {
        
        isLoading = true
        
        publisher = network.getAllBookedRides()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.isLoading = false
                    self?.hasError = true
                    self?.errorMessage = error as? APIError
                
                case .finished:
                    print("all booked rides")
                    self?.isLoading = false
                    self?.hasError = false
                    self?.isSuccess = true
                }
            }, receiveValue: { [weak self] data in
                self?.bookedRides = data.rides
            })
    }
    
    func getAllPublishedRides() {
        
        isLoading = true
        
        cancellable = network.getAllPublishedRides()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.isLoading = false
                    self?.hasError = true
                    self?.errorMessage = error as? APIError
                
                case .finished:
                    print("all published rides")
                    self?.isLoading = false
                    self?.hasError = false
                    self?.success = true
                }
            }, receiveValue: { [weak self] data in
                self?.publishedRides = data.data
            })
    }
}
