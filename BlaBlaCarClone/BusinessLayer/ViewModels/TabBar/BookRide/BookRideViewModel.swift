//
//  HomeViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 16/05/23.
//

import Foundation
import CoreLocation
import Combine

class BookRideViewModel: ObservableObject {
    
    @Published var isCalenderPresented = false
    @Published var isSearchPresented = false
    @Published var destSearchPresented = false
    @Published var isSeatsPresented = false
    
    @Published var dismiss = false
    
    @Published var date = Date.now
    @Published var noOfSeats: Int = 1
    @Published var startlocation = String()
    @Published var destination = String()
    @Published var orderBy = AppConstants.AppStrings.orderByTime
    
    @Published var startCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var destCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
    
    @Published var searchRideResponse = SearchRideResponse.response
    
    var publisher: AnyCancellable?
    let network = NetworkManager.shared
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeFormat.dayDateMonth
        
        if date.formatted(date: .long, time: .omitted) == Date.now.formatted(date: .long, time: .omitted) {
            return AppConstants.AppStrings.today
        } else {
            return dateFormatter.string(from: date)
        }
    }
    
    func searchRide() {
        
        self.isLoading = true
        
        publisher = network.search(data: makeCredentials())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoading = false
                    self.hasError = true
                    self.errorMessage = error as? APIError
                    
                case .finished:
                    print("done")
                    self.isLoading = false
                    self.hasError = false
                    self.isSuccess.toggle()
                }
            } receiveValue: { [weak self] data in
                self?.searchRideResponse = data
            }
    }
    
    func makeCredentials() -> SearchRide {
        
        let data = SearchRide(
            sourceLon: startCoordinates.longitude,
            sourceLat: startCoordinates.latitude,
            destLon: destCoordinates.longitude,
            destLat: destCoordinates.latitude,
            passCount: noOfSeats,
            date: DateFormatterUtil.shared.formatDate(date: date),
            orderBy: orderBy)
        
        print(data)
        return data
    }
    
    func disableSearch() -> Bool {
        if !startlocation.isEmpty && !destination.isEmpty {
            return false
        }
        return true
    }
}
