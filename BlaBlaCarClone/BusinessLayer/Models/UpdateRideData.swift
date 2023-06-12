//
//  UpdateRideData.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/06/23.
//

import Foundation

struct UpdateRideData: Codable {
    var publish: UpdateData
}

struct UpdateData: Codable {
    
    let source, destination: String?
    let sourceLongitude, sourceLatitude, destinationLongitude, destinationLatitude: Double?
    let passengersCount: Int?
    let date, time: String?
    let setPrice: Double?
    let aboutRide: String?

    enum CodingKeys: String, CodingKey {
        case source, destination
        case sourceLongitude = "source_longitude"
        case sourceLatitude = "source_latitude"
        case destinationLongitude = "destination_longitude"
        case destinationLatitude = "destination_latitude"
        case passengersCount = "passengers_count"
        case date, time
        case setPrice = "set_price"
        case aboutRide = "about_ride"
    }
}
