//
//  ChangePasswordViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 31/05/23.
//

import Foundation
import Combine

class ChangePasswordViewModel: ObservableObject {
    
    @Published var currentPw = String()
    @Published var newPw = String()
    @Published var confirmPw = String()
    
    @Published var passPrompt: Bool = false
    @Published var confirmPrompt: Bool = false
    
    var validation = Validations()
    
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
 
    let network = NetworkManager.shared
    var publisher: AnyCancellable?
    var userResponse: UserResponse = UserResponse.userResponse
    
    func changePassword(data: ChangePassword) {
        
        isLoading = true
        
        publisher = network.changePassword(data: data)
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
    
    func validPassword() {
        if !validation.isvalidPassword(newPw) {
            passPrompt = true
        } else {
            passPrompt = false
        }
    }
    
    func confirmPass() {
        if confirmPw != newPw {
            confirmPrompt = true
        } else {
            confirmPrompt = false
        }
    }
    
    func showButton() -> Bool {
        if !currentPw.isEmpty && !newPw.isEmpty && !confirmPw.isEmpty {
            if !passPrompt && !confirmPrompt {
                return true
            }
        }
        return false
    }
}
