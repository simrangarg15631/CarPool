//
//  HomeViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 16/05/23.
//

import Foundation
import MapKit

class BookRideViewModel: ObservableObject {
    
    @Published var isCalenderPresented = false
    @Published var isSearchPresented = false
    @Published var destSearchPresented = false
    @Published var isSeatsPresented = false
    
    @Published var date = Date.now
    @Published var noOfSeats: Int = 1
    @Published var startlocation = String()
    @Published var destination = String()
    
    var startCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var destCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    ////    @Published var region = MKCoordinateRegion()
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE d MMM"
        
        if date.formatted(date: .long, time: .omitted) == Date.now.formatted(date: .long, time: .omitted) {
            return AppConstants.AppStrings.today
        } else {
            return dateFormatter.string(from: date)
        }
    }
}
