//
//  VehicleResponse.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 29/05/23.
//

import Foundation

struct VehicleResponse: Codable {
    
    var status: VehicleStatus
}

struct VehicleStatus: Codable {
    var code: Int
    var message: String?
    var data: [Vehicle]
}

struct VehicleRes: Codable {
    
    var status: VehStatus
}

struct VehStatus: Codable {
    var code: Int
    var message: String?
    var data: Vehicle
}

struct Vehicle: Codable {
    
    var id: Int
    var country: String
    var number: String
    var brand: String
    var name: String
    var type: String
    var color: String
    var model: Int
    var userId: Int
    
    enum CodingKeys: String, CodingKey {
        case country
        case number = "vehicle_number"
        case brand = "vehicle_brand"
        case name = "vehicle_name"
        case type = "vehicle_type"
        case color = "vehicle_color"
        case model = "vehicle_model_year"
        case id
        case userId = "user_id"
    }
}

extension Vehicle {
    static let vehicleResponse = Vehicle(id: 17,
                                         country: "India",
                                         number: "5699",
                                         brand: "Maruti",
                                         name: "Ciaz",
                                         type: "Sedan",
                                         color: "White",
                                         model: 2016,
                                         userId: 29)
}
