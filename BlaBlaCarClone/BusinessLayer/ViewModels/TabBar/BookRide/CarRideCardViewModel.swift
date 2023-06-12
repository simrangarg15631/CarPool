//
//  CarRideCardViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 17/05/23.
//

import Foundation
import SwiftUI

class CarRideCardViewModel: ObservableObject {
    
    func colorCodeDist(distance: Double) -> Color {
        if distance <= 2 {
            return Color.green
        } else if distance > 2 && distance <= 10 {
            return Color.yellow
        } else {
            return Color.red
        }
    }
}
