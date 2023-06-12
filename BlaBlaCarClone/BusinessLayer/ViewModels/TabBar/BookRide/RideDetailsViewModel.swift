//
//  RideDetailsViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 02/06/23.
//

import Foundation
import Combine

class RideDetailsViewModel: ObservableObject {
    
    @Published var onConfirmRide: Bool = false
    
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
    
    @Published var bookRideResponse = BookRideResponse.reponse
    
    var publisher: AnyCancellable?
    let network = NetworkManager.shared
    
    func bookRide(data: BookRideData) {
        
        self.isLoading = true
        print(data)
        publisher = network.bookRide(data: data)
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
                self?.bookRideResponse = data
            }
    }
}
