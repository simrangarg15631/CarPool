//
//  EditVehicleViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 31/05/23.
//

import Foundation
import Combine

class EditVehicleViewModel: ObservableObject {
    @Published var country = String()
    @Published var number = String()
    @Published var brand = String()
    @Published var name = String()
    @Published var type = String()
    @Published var color = String()
    @Published var model = String()
    
    @Published var showPicker = false
    
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
    
    let network = NetworkManager.shared
    var publisher: AnyCancellable?
    var vehicleResponse: Vehicle = Vehicle.vehicleResponse
    
    func editVehicle(vehicleId: Int, data: VehicleData) {
        
        isLoading = true
        
        publisher = network.editVehicle(vehicleId: vehicleId, data: data)
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
                self?.vehicleResponse = data.status.data
            })
    }
    
    func showSave() -> Bool {
        
        if !country.isEmpty || !number.isEmpty || !brand.isEmpty ||
            !name.isEmpty || !type.isEmpty || !color.isEmpty || !model.isEmpty {
            return true
        }
        return false
    }
}
