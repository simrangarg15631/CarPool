//
//  DriverRofile.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 06/06/23.
//

import SwiftUI

struct DriverProfile: View {
    
    var imageUrl: URL?
    var name: String
    var averageRating: Double?
    
    var body: some View {
        
        HStack(spacing: 10) {
            
            if let imageUrl = imageUrl {
                AsyncImage(url: imageUrl) { phase in
                    if let image = phase.image {
                        // Image from Api
                        image
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                    } else {
                        // Activity Indicator Till the icon is loading show
                        ProgressView()
                            .frame(width: 40, height: 40)
                    }
                }
                
            } else {
                Image(systemName: AppConstants.AppImages.personCircle)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                
                HStack {
                    Image(systemName: AppConstants.AppImages.star)
                        .opacity(0.6)
                    Text(String(format: "%0.1f", averageRating ?? 0.0))
                }
                
            }
        }
    }
}

struct DriverRofile_Previews: PreviewProvider {
    static var previews: some View {
        DriverProfile(name: "Simran")
    }
}
