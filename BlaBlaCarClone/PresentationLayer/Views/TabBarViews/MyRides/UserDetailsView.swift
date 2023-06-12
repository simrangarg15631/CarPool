//
//  UserDetailsView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 08/06/23.
//

import SwiftUI

struct UserDetailsView: View {
    
    @Environment (\.dismiss) var dismiss
    
    var firstName: String
    var lastName: String
    var dob: String
    var phoneNumber: String?
    var phoneVerified: Bool?
    var image: URL?
    var averageRating: Double?
    var bio: String?
    var seats: Int?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text(firstName + " " + lastName)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text("\(DateFormatterUtil.shared.calculateAge(dob: dob)) y/o")
                        .font(.headline)
                        .opacity(0.6)
                    
                    if let phone = phoneNumber {
                        Text(phone)
                            .font(.headline)
                            .opacity(0.6)
                    }
                }
                
                Spacer()
                
                if let imageUrl = image {
                    AsyncImage(url: imageUrl) { phase in
                        if let image = phase.image {
                            // Image from Api
                            image
                                .resizable()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .padding(.top, 10)
                            
                        } else {
                            // Activity Indicator Till the icon is loading show
                            ProgressView()
                                .frame(width: 120, height: 120)
                        }
                    }
                    
                } else {
                    Image(systemName: AppConstants.AppImages.personCircle)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.top, 10)
                }
            }

            if let seats {
                Text("\(seats) \(seats>1 ? "seats" : "seat") booked")
                    .font(.headline)
                    .padding(.top)
            }
            
            Divider()
                .padding(.vertical)
            
            if let bio, !bio.isEmpty {
                
                Text("About " + firstName + " " + lastName)
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
                
                DetailView(image: AppConstants.AppImages.person, text: bio)
                    .opacity(0.8)
                    .padding(.top, 4)
            }
            
            DetailView(image: AppConstants.AppImages.star,
                       text: String(format: "%0.1f", averageRating ?? 0.0))
            .opacity(0.8)
            .padding(.top, 4)
            
            if let verified = phoneVerified, verified {
                
                DetailView(image: AppConstants.AppImages.filledCheckmark,
                           text: AppConstants.AppStrings.phoneVerified,
                           color: .accentColor)
                    .padding(.top, 4)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // Back button
                ImageButton(image: AppConstants.AppImages.chevronleft) {
                    self.dismiss()
                }
                .font(.subheadline)
            }
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserDetailsView(firstName: "Simran",
                            lastName: "Garg",
                            dob: "2001-08-24",
                            bio: "gu9",
                            seats: 1)
        }
    }
}
