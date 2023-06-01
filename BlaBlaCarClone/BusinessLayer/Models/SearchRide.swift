//
//  SearchRide.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 26/05/23.
//

import Foundation

struct SearchRide: Codable {
    
    var sourceLon: String
    var sourceLat: String
    var destLon: String
    var destLat: String
    var passCount: Int
    var date: String
    
    enum CodingKeys: String, CodingKey {
        case sourceLon = "source_longitude"
        case sourceLat = "source_latitude"
        case destLon = "destination_longitude"
        case destLat = "destination_latitude"
        case passCount = "pass_count"
        case date
    }
    
}
