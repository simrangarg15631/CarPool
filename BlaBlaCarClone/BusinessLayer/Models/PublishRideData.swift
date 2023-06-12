//
//  PublishRideData.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 02/06/23.
//

import Foundation

struct PublishRideData: Codable {
    let publish: Publish
}

// MARK: - Publish
struct Publish: Codable {
    let source, destination: String
    let sourceLongitude, sourceLatitude, destinationLongitude, destinationLatitude: Double
    let passengersCount: Int
    let addCity: String?
    let addCityLongitude: Double?
    let addCityLatitude: Double?
    let date, time: String
    let setPrice: Double
    let aboutRide: String?
    let vehicleID: Int
    let bookInstantly, midSeat: Bool?
    let estimateTime: String?
    let selectRoute: DirectionsResponse?

    enum CodingKeys: String, CodingKey {
        case source, destination
        case sourceLongitude = "source_longitude"
        case sourceLatitude = "source_latitude"
        case destinationLongitude = "destination_longitude"
        case destinationLatitude = "destination_latitude"
        case passengersCount = "passengers_count"
        case addCity = "add_city"
        case addCityLongitude = "add_city_longitude"
        case addCityLatitude = "add_city_latitude"
        case date, time
        case setPrice = "set_price"
        case aboutRide = "about_ride"
        case vehicleID = "vehicle_id"
        case bookInstantly = "book_instantly"
        case midSeat = "mid_seat"
        case estimateTime = "estimate_time"
        case selectRoute = "select_route"
    }
}
