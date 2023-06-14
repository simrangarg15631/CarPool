//
//  MyRidesCardView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 06/06/23.
//

import SwiftUI

struct MyRidesCardView: View {
    
    @StateObject var cardVm = MyRidescardViewModel()
    var published: Bool
    var rideData: PublishDetails
    var seats: Int?
    var status: String?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                
                Text(rideData.source.capitalized)
                    .font(.headline)
                    .frame(width: 78, height: 15)
                
                Image(systemName: AppConstants.AppImages.arrow)
                    .font(.subheadline)
                
                Text(rideData.destination.capitalized)
                    .font(.headline)
                    .frame(width: 78, height: 15, alignment: .leading)
                
                Spacer()
                
                Text(cardVm.title)
                    .font(.caption)
                    .foregroundColor(cardVm.color)
                    .bold()
                    .padding(8)
                    .background(cardVm.color.opacity(0.1))
            }
            
            if published {
                Text("Rs. \(String(format: "%0.1f", rideData.setPrice)) per seat")
                    .font(.subheadline)
            } else {
                if let seats = seats {
                    Text("Rs. \(String(format: "%0.1f", rideData.setPrice * Double(seats)))")
                        .font(.subheadline)
                }
            }
            
            DetailView(image: AppConstants.AppImages.calendar, text: rideData.date)
                .padding(.top)
            
            DetailView(image: AppConstants.AppImages.clock,
                       text: DateFormatterUtil.shared.datetimeFormat(
                        dateTime: rideData.time,
                        format: DateTimeFormat.hourMin))
            
            if !published {
                if let seat = seats {
                    DetailView(image: AppConstants.AppImages.person,
                               text: """
\(seat) \(seat > 1 ? AppConstants.AppStrings.passengers : AppConstants.AppStrings.passenger)
""")
                }
            }
            
            if published {
                
                Divider()
                    .padding(.top)
                
                Text("""
Published on: \
\(DateFormatterUtil.shared.datetimeFormat(dateTime: rideData.createdAt,
format: DateTimeFormat.dateMonYearTime))
""")
                    .padding(.top)
                    .opacity(0.7)
                
            }
        }
        .padding()
        .frame(maxWidth: UIScreen.main.bounds.width - 50)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: Color.gray, radius: 2)
        .onAppear {
            if published {
                cardVm.checkStatus(status: rideData.status)
            } else {
                guard let status = status else {
                    return
                }
                cardVm.checkStatus(status: status)
            }
        }
    }
}

struct MyRidesCardView_Previews: PreviewProvider {
    static var previews: some View {
        MyRidesCardView(published: true,
                        rideData: PublishRideResponse.publishRideResponse.publish,
                        seats: 2,
                        status: AppConstants.AppStrings.cancelBooking)
    }
}
