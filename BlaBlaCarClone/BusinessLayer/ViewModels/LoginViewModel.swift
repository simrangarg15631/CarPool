//
//  LoginViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/05/23.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var email = String()
    @Published var password = String()
    
    @Published var logInActive: Bool = false
    @Published var hasError: Bool = false
    @Published var isLoading: Bool = false
    @Published var presenSheet: Bool = false
    @Published var errorMessage: APIError?
    @Published var userResponse = UserResponse.userResponse
    
    let network = NetworkManager.shared
    var publisher: AnyCancellable?
    
    func disableButton() -> Bool {
        if !email.isEmpty && !password.isEmpty {
            return false
        }
        return true
    }
    
    func logIn() {
        
        isLoading.toggle()
        
        publisher = network.signUpLogIn(
            type: AppConstants.ButtonLabels.logIn,
            data: UserData(user: UserDetails(email: email, password: password)))
        
        .receive(on: DispatchQueue.main)
        
        .sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                print(error)
                self?.isLoading.toggle()
                self?.hasError.toggle()
                self?.errorMessage = error as? APIError
                
            case .finished:
                print("successful")
                self?.isLoading.toggle()
                self?.logInActive.toggle()
            }
        } receiveValue: { [weak self] data in
            self?.userResponse = data
        }
    }
}
