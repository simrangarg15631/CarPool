//
//  MyRidesView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 18/05/23.
//

import SwiftUI

struct FutureTravelView: View {
    var body: some View {
        
        VStack {
            
            Image(AppConstants.AppImages.myRides)
                .resizable()
                .frame(width: 300, height: 300)
            
            Text(AppConstants.AppStrings.futureTravelPlans)
                .font(.title)
                .fontWeight(.semibold)
                .opacity(0.9)
                .multilineTextAlignment(.center)
            
            Text(AppConstants.AppStrings.findPerfectRide)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            Spacer()
        }
        .padding(20)
    }
}

struct FutureTravelView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FutureTravelView()
        }
    }
}
