//
//  NoRidesView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 08/06/23.
//

import SwiftUI

struct NoRidesView: View {
    
    var title: String
    
    var body: some View {
        
        VStack {
            
            Image(AppConstants.AppImages.myRides)
                .resizable()
                .frame(maxWidth: 300, maxHeight: 300)
                .padding(.top)
            
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 30)
                .opacity(0.8)
            
            Spacer()
        }
    }
}

struct NoRidesView_Previews: PreviewProvider {
    static var previews: some View {
        NoRidesView(title: AppConstants.AppStrings.noRidesPublished)
    }
}
