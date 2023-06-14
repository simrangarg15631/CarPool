//
//  CarRidesListView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 17/05/23.
//

import SwiftUI

struct CarRideCardView: View {
    
    @StateObject var cardVm = CarRideCardViewModel()
    var ride: RideDetails
    var seats: Int
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack(spacing: 10) {
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(DateFormatterUtil.shared.datetimeFormat(
                        dateTime: ride.publish.time,
                        format: DateTimeFormat.hourMin))
                        .font(.headline)
                    
                    if let timeTaken = ride.publish.estimateTime {

                        Text(DateFormatterUtil.shared.datetimeFormat(
                            dateTime: timeTaken,
                            format: DateTimeFormat.hourMin))
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    if let arrTime = ride.reachTime {
                        Text(DateFormatterUtil.shared.datetimeFormat(
                            dateTime: arrTime,
                            format: DateTimeFormat.hourMin))
                            .font(.headline)
                            .padding(.top, 50)
                    }
                }
                
                CustomShape()
                    .stroke(Color.black, lineWidth: 3)
                    .frame(maxWidth: 10)
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 10) {
                    CarLocationView(
                        title: ride.publish.source)
                    
                    Spacer()
                    
                    CarLocationView(
                        title: ride.publish.destination)
                    .padding(.top, 50)
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("\(AppConstants.AppStrings.rs) \(Int(ride.publish.setPrice)/seats)")
                        .font(.headline)
                    Text("\(ride.publish.passengersCount) \(AppConstants.AppStrings.seatsLeft)")
                    Spacer()
                }
            }
            
            Divider()
            
            DriverProfile(imageUrl: ride.imageURL, name: ride.name, averageRating: ride.averageRating)
                .padding(.top, 10)

//                if let instant = ride.publish.bookInstantly {
//                    if instant{
//                        Image(systemName: AppConstants.AppImages.bolt)
//                            .font(.title2)
//                            .opacity(0.8)
//                    }
//                }
        }
        .padding()
        .frame(maxWidth: UIScreen.main.bounds.width - 50)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: Color.gray, radius: 2)
        
    }
}

struct CarRidesListView_Previews: PreviewProvider {
    static var previews: some View {
        CarRideCardView(ride: RideDetails.details, seats: 1)
    }
}
