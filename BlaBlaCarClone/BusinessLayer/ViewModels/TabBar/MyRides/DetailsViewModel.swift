//
//  DetailsViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 08/06/23.
//

import Foundation
import Combine

class DetailsViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var isSuccess = false
    @Published var hasError = false
    @Published var errorMessage: APIError?

    @Published var rideData: PublishDetails = PublishRideResponse.publishRideResponse.publish
    @Published var passengersArray: [PassengerData] = []
    @Published var fromDetails: Bool = true
    var publisher: AnyCancellable?
    let network = NetworkManager.shared
    
    func getPassengersInfo(publishId: Int) {
        isLoading = true
        
        publisher = network.getPassengersInfo(publishId: publishId)
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
                self?.passengersArray = data.passengers
                self?.rideData = data.data
            })
    }
    
}
