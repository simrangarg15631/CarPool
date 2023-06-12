//
//  PublishRideResponse.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 02/06/23.
//

import Foundation

struct PublishRideResponse: Codable {
    let code: Int
    let publish: PublishDetails
}

// MARK: - Publish
struct PublishDetails: Codable {
    let id: Int
    let source, destination: String
    let passengersCount: Int
    let addCity: String?
    let date, time: String
    let setPrice: Double
    let aboutRide: String?
    let userID: Int
    let createdAt: String
    let sourceLatitude, sourceLongitude, destinationLatitude, destinationLongitude: Double
    let vehicleID: Int?
//    let bookInstantly, midSeat: Bool?
    let selectRoute: DirectionsResponse?
    let status: String
    let estimateTime: String?
    let addCityLongitude, addCityLatitude: Double?
    let distance: Double?

    enum CodingKeys: String, CodingKey {
        
        case id, source, destination
        case passengersCount = "passengers_count"
        case addCity = "add_city"
        case date, time
        case setPrice = "set_price"
        case aboutRide = "about_ride"
        case userID = "user_id"
        case createdAt = "created_at"
        case sourceLatitude = "source_latitude"
        case sourceLongitude = "source_longitude"
        case destinationLatitude = "destination_latitude"
        case destinationLongitude = "destination_longitude"
        case vehicleID = "vehicle_id"
//        case bookInstantly = "book_instantly"
//        case midSeat = "mid_seat"
        case selectRoute = "select_route"
        case status
        case estimateTime = "estimate_time"
        case addCityLongitude = "add_city_longitude"
        case addCityLatitude = "add_city_latitude"
        case distance
    }
}

extension PublishRideResponse {
    static let publishRideResponse = PublishRideResponse(code: 0, publish:
                                                            PublishDetails(id: 0,
                                                                           source: "Chennaifgergrgrg3g34gf35g4rg",
                                                                           destination: "Mohaliryerhyeu5u46u46uhtghjet",
                                                                           passengersCount: 1,
                                                                           addCity: "Mp",
                                                                           date: "2023-05-03",
                                                                           time: "2000-01-01T17:00:00.000Z",
                                                                           setPrice: 150,
                                                                           aboutRide: "",
                                                                           userID: 0,
                                                                           createdAt: "2023-06-05T12:42:12.565Z",
                                                                           sourceLatitude: 0,
                                                                           sourceLongitude: 0,
                                                                           destinationLatitude: 0,
                                                                           destinationLongitude: 0,
                                                                           vehicleID: 0,
                                                                           selectRoute: nil,
                                                                           status: "completed",
                                                                           estimateTime: "2000-01-01T17:00:00.000Z",
                                                                           addCityLongitude: nil,
                                                                           addCityLatitude: nil,
                                                                           distance: 0.0))
}
