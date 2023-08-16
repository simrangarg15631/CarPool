//
//  EnterEmailViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 05/06/23.
//

import Foundation
import Combine

class EnterEmailViewModel: ObservableObject {
    
    @Published var email = String()
    
    @Published var errorMessage: APIError?
    
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
    
    var userResponse: Status?
    var publisher: AnyCancellable?
    let network = NetworkManager.shared
    
    func sendOtp(email: String) {
        
        isLoading = true
        
        publisher = network.forgotPassword(data: UserDetails(email: email))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isLoading.toggle()
                    self?.hasError.toggle()
                    self?.isSuccess = false
                    self?.errorMessage = error as? APIError
                    
                case .finished:
                    print("verify phone")
                    self?.isLoading.toggle()
                    self?.isSuccess = true
                }
                
            }, receiveValue: { [weak self] data in
                self?.userResponse = data
            })
        
    }
}
