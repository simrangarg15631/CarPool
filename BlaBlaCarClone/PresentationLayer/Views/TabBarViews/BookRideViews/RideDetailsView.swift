//
//  RideDetailsView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 19/05/23.
//

import SwiftUI

struct RideDetailsView: View {
    
    @StateObject var rideVm = RideDetailsViewModel()
    @Environment (\.dismiss) var dismiss
    var ride: RideDetails
    @ObservedObject var homeVm: BookRideViewModel
    
    var body: some View {
        
        VStack {
            
            Rectangle()
                .foregroundColor(.gray.opacity(0.1))
                .frame(height: 10)
            
            ScrollView(showsIndicators: false) {
                
                LazyVStack(alignment: .leading) {
                    
                    // Trip Info
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text(AppConstants.AppHeadings.tripInfo)
                            .font(.headline)
                            .padding(.bottom)
                        
                        DetailView(
                            image: AppConstants.AppImages.calendar,
                            text: ride.publish.date)
                        
                        if let estimateTime = ride.publish.estimateTime {
                            DetailView(image: AppConstants.AppImages.clock,
                                       text: DateFormatterUtil.shared.datetimeFormat(
                                        dateTime: estimateTime,
                                        format: DateTimeFormat.hourMin)
                            )}
                        
                        if let selectRoute = ride.publish.selectRoute?.routes {
                            
                            if !selectRoute.isEmpty {
                                
                                if !selectRoute[0].legs.isEmpty {
                                    
                                    DetailView(
                                        image: AppConstants.AppImages.distance,
                                        text: selectRoute[0].legs[0].distance.text)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    // PickUp drop location
                    HStack(spacing: 16) {
                        
                        CustomShape()
                            .stroke(Color.black, lineWidth: 1)
                            .frame(maxWidth: 10)
                            .padding(.bottom, 25)
                        
                        VStack(alignment: .leading) {
                            
                            RideDetailComponent(
                                title: ride.publish.source,
                                time: DateFormatterUtil.shared.datetimeFormat(
                                    dateTime: ride.publish.time,
                                format: DateTimeFormat.hourMin))
                            .padding(.bottom)
                            
                            RideDetailComponent(
                                title: ride.publish.destination,
                                time: DateFormatterUtil.shared.datetimeFormat(dateTime: ride.reachTime ?? "",
                                                                          format: DateTimeFormat.hourMin))
                            .padding(.top)
                        }
                    }
                    .padding()
                    
                    if !rideVm.onConfirmRide {
                        
                        Divider()
                        
                        // Seat and Price
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(AppConstants.AppStrings.seatsLeft)
                                    .font(.headline)
                                    .opacity(0.7)
                                
                                Spacer()
                                
                                Text("\(ride.publish.passengersCount)")
                            }
                            
                            HStack {
                                Text(AppConstants.AppStrings.pricePerSeat)
                                    .font(.headline)
                                    .opacity(0.7)
                                
                                Spacer()
                                
                                Text("\(AppConstants.AppStrings.rs) \(Int(ride.publish.setPrice)/homeVm.noOfSeats)")
                                
                            }
                        }
                        .padding()
                    }
                    
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.1))
                        .frame(height: 10)
                    
                    // Driver Profile
                    VStack(alignment: .leading, spacing: 24) {
                        
                        DriverProfile(imageUrl: ride.imageURL, name: ride.name, averageRating: ride.averageRating)
                        
//                                                HStack {
//                                                    Image(systemName: AppConstants.AppImages.car)
//                                                        .font(.headline)
//                                                        .opacity(0.7)
//
//                                                    Text("Car Name (Color)")
//                                                        .font(.headline)
//                                                        .opacity(0.7)
//
//                                                    Spacer()
//                                                }
                        
                    }
                    .padding()
                    
                    if let aboutRide = ride.aboutRide, !aboutRide.isEmpty {
                        
                        Divider()
                        // Ride Preferences
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text(AppConstants.AppHeadings.aboutRide)
                                .font(.headline)
                            
                            Text(aboutRide)
                                .opacity(0.7)
                        }
                        .padding()
                    }
                    
                    if rideVm.onConfirmRide {
                        
                        Divider()
                        
                        // Seat and Price
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(AppConstants.AppStrings.bookedSeats)
                                    .font(.subheadline)
                                    .bold()
                                    .opacity(0.7)
                                
                                Spacer()
                                
                                Text("x\(homeVm.noOfSeats)")
                            }
                            
                            HStack {
                                Text(AppConstants.AppStrings.totalAmount)
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text("\(AppConstants.AppStrings.rs) \(Int(ride.publish.setPrice))")
                            }
                            
                        }
                        .padding()
                    }
                    
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.1))
                        .frame(height: 50)
                }
                
            }
            
            if rideVm.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            if !rideVm.onConfirmRide {
                // Continue Button
                Button {
                    rideVm.onConfirmRide.toggle()
                } label: {
                    ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.contnue)
                        .cornerRadius(20)
                }
                .padding()
            } else {
                // Confirm Button
                Button {
                    // Call Api to book ride
                    rideVm.bookRide(data: BookRideData(passenger: Passenger(
                        publishId: ride.publish.id,
                        seats: homeVm.noOfSeats)))
                    
                } label: {
                    ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.confirmRide)
                        .cornerRadius(20)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $rideVm.isSuccess, destination: {
            // Navigate to View Showing ride booked
            RideBookedView(homeVm: homeVm)
        })
        .alert("", isPresented: $rideVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = rideVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                TitleView(title: AppConstants.AppHeadings.rideDetails)
            }
        }
        .onAppear {
            if homeVm.dismiss {
                self.dismiss()
            }
        }
    }
}

struct RideDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RideDetailsView(ride: RideDetails.details, homeVm: BookRideViewModel())
        }
    }
}
