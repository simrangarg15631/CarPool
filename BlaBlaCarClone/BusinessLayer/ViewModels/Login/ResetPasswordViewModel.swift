//
//  ResetPasswordViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 05/06/23.
//

import Foundation
import Combine

class ResetPasswordViewModel: ObservableObject {
    
    @Published var newPassword = String()
    @Published var confirmPassword = String()
    @Published var passPrompt: Bool = false
    @Published var confirmPrompt: Bool = false
    @Published var errorMessage: APIError?
    
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
    
    var userResponse: Status?
    var publisher: AnyCancellable?
    let network = NetworkManager.shared
    let validation = Validations()
    
    func resetPassword(data: ChangePassword) {
        
        isLoading = true
        
        publisher = network.resetPassword(data: data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isLoading.toggle()
                    self?.hasError.toggle()
                    self?.errorMessage = error as? APIError
                    
                case .finished:
                    print("password changed")
                    self?.isLoading.toggle()
                    self?.isSuccess.toggle()
                }
                
            }, receiveValue: { [weak self] data in
                self?.userResponse = data
            })
        
    }
    
    /// To check if password is valid and on that basis show message to user
    func validPassword() {
        if !newPassword.isEmpty && !validation.isvalidPassword(newPassword) {
            passPrompt = true
        } else {
            passPrompt = false
        }
    }
    
    /// To check if confirmPassword matches with password and on that basis show message to user
    func confirmPass() {
        if !confirmPassword.isEmpty && confirmPassword != newPassword {
            confirmPrompt = true
        } else {
            confirmPrompt = false
        }
    }
    
    func disableButton() -> Bool {
        if !newPassword.isEmpty && !confirmPassword.isEmpty {
            if !passPrompt && !confirmPrompt {
                return false
            }
        }
        return true
    }
}
