//
//  TabBarViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 26/05/23.
//

import Foundation
import Combine

class TabBarViewModel: ObservableObject {
    
    @Published var isFirst = true
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var userResponse: UserResponse = UserResponse.userResponse
    @Published var vehicleResponse: [Vehicle] = []
    
    let network = NetworkManager.shared
    var publisher: AnyCancellable?
    var subscriber: AnyCancellable?
    
    func getUser() {
        isLoading = true
        publisher = network.getUserInfo()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.isLoading = false
                    self?.errorMessage = error as? APIError
                
                case .finished:
                    print("success users")
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] data in
                self?.userResponse = data
            })
    }
    
    func getAllVehicles() {
        isLoading = true
        subscriber = network.getVehicle()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.isLoading = false
                    self?.errorMessage = error as? APIError
                
                case .finished:
                    print("success vehicles")
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] data in
                self?.vehicleResponse = data.data
            })
    }
}
