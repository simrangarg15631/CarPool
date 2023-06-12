//
//  SearchRide.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 26/05/23.
//

import Foundation

struct SearchRide: Codable {
    
    var sourceLon: Double
    var sourceLat: Double
    var destLon: Double
    var destLat: Double
    var passCount: Int
    var date: String
    var orderBy: String
    
    enum CodingKeys: String, CodingKey {
        case sourceLon = "source_longitude"
        case sourceLat = "source_latitude"
        case destLon = "destination_longitude"
        case destLat = "destination_latitude"
        case passCount = "passengers_count"
        case date
        case orderBy = "order_by"
    }
    
}

struct SearchRideResponse: Codable {
    
    var code: Int
    var message: String?
    var data: [RideDetails]
}

struct RideDetails: Codable {
    
    let id: Int
    let name: String
    let reachTime: String?
    let imageURL: URL?
    let averageRating: Double?
    let aboutRide: String?
    let publish: PublishDetails
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case reachTime = "reach_time"
        case imageURL = "image_url"
        case averageRating = "average_rating"
        case aboutRide = "about_ride"
        case publish
    }
    
}

extension SearchRideResponse {
    static let response = SearchRideResponse(code: 0, data: [RideDetails.details])
}

extension RideDetails {
    static let details = RideDetails(id: 0,
                                     name: "Simran",
                                     reachTime: "2023-06-30T21:06:00.000Z",
                                     imageURL: nil,
                                     averageRating: nil,
                                     aboutRide: "No Luggage",
                                     publish: PublishRideResponse.publishRideResponse.publish)
}
