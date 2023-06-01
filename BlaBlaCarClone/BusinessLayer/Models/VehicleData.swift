//
//  VehicleDataModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 29/05/23.
//

import Foundation

struct VehicleData: Codable {
    
    var vehicle: VehicleInfo
}

struct VehicleInfo: Codable {
    
    var country: String?
    var number: String?
    var brand: String?
    var name: String?
    var type: String?
    var color: String?
    var model: Int?

    enum CodingKeys: String, CodingKey {
        case country
        case number = "vehicle_number"
        case brand = "vehicle_brand"
        case name = "vehicle_name"
        case type = "vehicle_type"
        case color = "vehicle_color"
        case model = "vehicle_model_year"
    }
}
