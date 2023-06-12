//
//  EnterOTPViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 26/05/23.
//

import Foundation
import Combine

class EnterOTPViewModel: ObservableObject {
    
    @Published var otp1 = String()
    @Published var otp2 = String()
    @Published var otp3 = String()
    @Published var otp4 = String()
    @Published var errorMessage: APIError?
    
    @Published var isLoading = false
    @Published var hasError = false
    @Published var verified = false
    
    var userResponse = UserResponse.userResponse
    var publisher: AnyCancellable?
    let network = NetworkManager.shared
    
    func verifyphone(phone: String) {
        
        isLoading = true
        let passcode = otp1 + otp2 + otp3 + otp4
        
        publisher = network.verifyPhone(data: UserDetails(phoneNumber: Int(phone), passcode: passcode))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isLoading.toggle()
                    self?.hasError.toggle()
                    self?.errorMessage = error as? APIError
                    
                case .finished:
                    print("verify phone")
                    self?.isLoading.toggle()
                    self?.verified.toggle()
                }
                
            }, receiveValue: { [weak self] data in
                self?.userResponse = data
            })
        
    }
    
}
