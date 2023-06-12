//
//  BookRideDetailsViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 07/06/23.
//

import Foundation
import Combine

class BookRideDetailsViewModel: ObservableObject {
    
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var userResponse = UserInfoResponse.userInfo
    @Published var hasError = false
    @Published var response: Status = Status(code: 200)
    @Published var isSuccess = false
    @Published var anyError = false
    @Published var success = false
    @Published var isPresented = false
    
    let network = NetworkManager.shared
    var publisher: AnyCancellable?
    var cancellable: AnyCancellable?
    
    func getUserInfo(id: Int) {
        isLoading = true
        publisher = network.getUserInfoById(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.isLoading = false
                    self?.hasError = true
                    self?.errorMessage = error as? APIError
                
                case .finished:
                    print("success users")
                    self?.isLoading = false
                    self?.success = true
                    
                }
            }, receiveValue: { [weak self] data in
                self?.userResponse = data
            })
    }
    
    func cancelBooking(id: Int) {
        isLoading = true
        publisher = network.cancelBooking(data: CancelBookingModel(id: id))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.isLoading = false
                    self?.anyError = true
                    self?.errorMessage = error as? APIError
                
                case .finished:
                    print("success users")
                    self?.isLoading = false
                    self?.isSuccess = true
                }
            }, receiveValue: { [weak self] data in
                self?.response = data
            })
    }
}
