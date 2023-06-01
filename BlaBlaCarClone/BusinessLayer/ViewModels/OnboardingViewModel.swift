//
//  OnboardingViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/05/23.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    
    @Published var fromSignUpView: Bool = false
    @Published var path: [Int] = []
}
