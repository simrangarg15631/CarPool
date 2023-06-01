//
//  FilterModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 17/05/23.
//

import Foundation

struct FilterModel: Identifiable {
    
    var id = UUID()
    var image: String?
    var title: String
    var isChecked: Bool
}
