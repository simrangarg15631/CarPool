//
//  EditProfilePicViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 29/05/23.
//

import Foundation
import Combine

class EditProfilePicViewModel: ObservableObject {
    
    @Published var profilePic: Data?
    
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
    
    let network = NetworkManager.shared
    var publisher: AnyCancellable?
    var userResponse: UserResponse = UserResponse.userResponse
    
    func addPic(image: Data) {
        
        isLoading = true
        
        publisher = network.addImage(image: image)
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
                    self?.hasError = false
                    self?.isSuccess = true
                }
            }, receiveValue: { [weak self] data in
                self?.userResponse = data
            })
    }
}
