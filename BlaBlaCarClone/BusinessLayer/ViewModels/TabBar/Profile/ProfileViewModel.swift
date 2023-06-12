//
//  ProfileViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 23/05/23.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
    
    @Published var anyError = false
    @Published var success = false
 
    let network = NetworkManager.shared
    var publisher: AnyCancellable?
    var cancellable: AnyCancellable?
    var userResponse: Response?
    var response: UserResponse?
    
    func signOut() {
        
        isLoading = true
        
        publisher = network.signOut()
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
    
    func deleteAccount() {
        
        publisher = network.deleteAccount()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.isLoading = false
                    self?.anyError = true
                    self?.errorMessage = error as? APIError
                    
                case .finished:
                    print("success")
                    self?.isLoading = false
                    self?.success = true
                }
            }, receiveValue: { [weak self] data in
                self?.response = data
            })
        
    }
}
