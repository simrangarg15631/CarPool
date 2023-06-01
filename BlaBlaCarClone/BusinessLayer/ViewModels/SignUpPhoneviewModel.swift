//
//  SignUpPhoneviewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 26/05/23.
//

import Foundation
import Combine

class SignUpPhoneViewModel: ObservableObject {
   
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isPresented = false
    @Published var errorMessage: APIError?
    
    var publisher: AnyCancellable?
    let network = NetworkManager.shared
    var userResponse = UserResponse.userResponse
    
    func sendOTP(phone: String) {
        
        isLoading.toggle()
        
        publisher = network.sendOTP(phone: UserDetails(phoneNumber: Int(phone)))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isLoading.toggle()
                    self?.hasError.toggle()
                    self?.errorMessage = error as? APIError
                    
                case .finished:
                    print("sentOtp")
                    self?.isLoading.toggle()
                    self?.isPresented.toggle()
                }
                
            }, receiveValue: { [weak self] response in
                self?.userResponse = response
            })
    }
    
}
