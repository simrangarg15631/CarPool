//
//  MyRidesCardViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 06/06/23.
//

import Foundation
import SwiftUI

class MyRidescardViewModel: ObservableObject {
    
    @Published var title: String = AppConstants.AppStrings.upcoming
    @Published var color: Color = .green
    
    // Check status of ride and decide text and color for that status
    func checkStatus(status: String) {
        if status == AppConstants.AppStrings.pending || status == AppConstants.AppStrings.rideCompleted {
            title = AppConstants.AppStrings.upcoming
            color = .yellow
        } else if status == AppConstants.AppStrings.cancelled || status == AppConstants.AppStrings.cancelBooking {
            title = AppConstants.AppStrings.cancelled.uppercased()
            color = .red
        } else if status == AppConstants.AppStrings.completed || status == AppConstants.AppStrings.rideCompleted {
            title = AppConstants.AppStrings.completed.uppercased()
            color = .green
        }
    }
}
