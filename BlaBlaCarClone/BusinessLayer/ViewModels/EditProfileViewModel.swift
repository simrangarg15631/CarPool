//
//  EditProfileViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 26/05/23.
//

import Foundation
import Combine

class EditProfileViewModel: ObservableObject {
    
    @Published var firstName = String()
    @Published var lastName = String()
    @Published var dob = Date()
    @Published var myDate = String()
    @Published var email = String()
    @Published var gender: String = AppConstants.AppStrings.male
    @Published var phone = String()
    @Published var bio = String()
    @Published var showPicker: Bool = false
    
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
    
    var genderType = [AppConstants.AppStrings.male, AppConstants.AppStrings.female, AppConstants.AppStrings.notSay]
    let network = NetworkManager.shared
    var publisher: AnyCancellable?
    var userResponse: UserResponse = UserResponse.userResponse
    
    func editInfo(data: UserData) {
        
        isLoading = true
        
        publisher = network.editUserInfo(data: data)
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
