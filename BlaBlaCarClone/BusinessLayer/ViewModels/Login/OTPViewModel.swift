//
//  OTPViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 05/06/23.
//

import Foundation
import Combine

class OTPViewModel: ObservableObject {
    
    @Published var otp1 = String()
    @Published var otp2 = String()
    @Published var otp3 = String()
    @Published var otp4 = String()
    @Published var otp1Emp: Bool = false
    @Published var otp2Emp: Bool = false
    @Published var otp3Emp: Bool = false
    @Published var otp4Emp: Bool = false
    
    @Published var errorMessage: APIError?
    
    @Published var isLoading = false
    @Published var hasError = false
    @Published var verified = false
    
    var userResponse: Status?
    var publisher: AnyCancellable?
    let network = NetworkManager.shared
    
    func verifyOtp(email: String) {
        
        isLoading = true
        let passcode = otp1 + otp2 + otp3 + otp4
        
        publisher = network.verifyOtp(data: UserDetails(email: email, otp: Int(passcode)))
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
