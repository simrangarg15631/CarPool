//
//  VehicleInfoViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 31/05/23.
//

import Foundation
import Combine

class VehicleInfoViewModel: ObservableObject {
    
    @Published var isPresented = false
    
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
 
    let network = NetworkManager.shared
    var publisher: AnyCancellable?
    var userResponse: UserResponse = UserResponse.userResponse
    
    func deleteVehicle(vehicleId: Int) {
        
        isLoading = true
        
        publisher = network.deleteVehicle(vehicleId: vehicleId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.isLoading = false
                    self?.hasError = true
                    self?.errorMessage = error as? APIError
                    
                case .finished:
                    print("success")
                    self?.isLoading = false
                    self?.isSuccess = true
                }
            }, receiveValue: { [weak self] data in
                self?.userResponse = data
            })
    }
}
