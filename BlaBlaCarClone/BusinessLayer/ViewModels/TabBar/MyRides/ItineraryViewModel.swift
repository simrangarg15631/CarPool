//
//  ItineraryViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/06/23.
//

import Foundation
import CoreLocation

class ItineraryViewModel: ObservableObject {
    
    @Published var date = Date()
    @Published var time = Date()
    @Published var source = String()
    @Published var destination = String()
    
    @Published var sourceCoord = CLLocationCoordinate2D()
    @Published var destCoord = CLLocationCoordinate2D()
    
    @Published var srcPresent = false
    @Published var destPresent = false
}
