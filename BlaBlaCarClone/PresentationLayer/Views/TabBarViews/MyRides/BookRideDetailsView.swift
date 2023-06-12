//
//  BookRideDetailsView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 06/06/23.
//

import SwiftUI

struct BookRideDetailsView: View {
    
    @StateObject var bookRideVm = BookRideDetailsViewModel()
    var rideData: Rides
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            LazyVStack(alignment: .leading) {
                
                // Trip Info
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text(AppConstants.AppHeadings.tripInfo)
                        .font(.headline)
                        .padding(.bottom)
                    
                    // Date
                    DetailView(
                        image: AppConstants.AppImages.calendar,
                        text: rideData.ride.date)
                    
                    if let selectRoute = rideData.ride.selectRoute?.routes {
                        
                        if !selectRoute.isEmpty {
                            
                            if !selectRoute[0].legs.isEmpty {
                                
                                // Time taken
                                DetailView(
                                    image: AppConstants.AppImages.clock,
                                    text: selectRoute[0].legs[0].duration.text)
                                
                                // Distance
                                DetailView(
                                    image: AppConstants.AppImages.distance,
                                    text: selectRoute[0].legs[0].distance.text)
                            }
                        }
                    }
                }
                .padding()
                
                Divider()
                
                // PickUp Drop location
                HStack(spacing: 16) {
                    
                    CustomShape()
                        .stroke(Color.black, lineWidth: 1)
                        .frame(maxWidth: 10)
                        .padding(.bottom, 25)
                    
                    VStack(alignment: .leading) {
                        
                        // Pick up location
                        RideDetailComponent(
                            title: rideData.ride.source,
                            time: DateFormatterUtil.shared.datetimeFormat(
                                dateTime: rideData.ride.time,
                                format: AppConstants.DateTimeFormat.hourMin) )
                        .padding(.bottom)
                        
                        // Drop location
                        RideDetailComponent(
                            title: rideData.ride.destination,
                            time: "")
                        .padding(.top)
                    }
                }
                .padding()
                
                Divider()
                
                VStack(spacing: 10) {
                    
                    HStack {
                        Text(AppConstants.AppStrings.seatsBooked)
                            .font(.headline)
                            .opacity(0.7)
                        
                        Spacer()
                        
                        Text("\(rideData.seat)")
                    }
                    
                    HStack {
                        Text(AppConstants.AppStrings.price)
                            .font(.headline)
                            .opacity(0.7)
                        
                        Spacer()
                        
                        Text("Rs. \(String(format: "%0.1f", rideData.ride.setPrice * Double(rideData.seat)))")
                    }
                }
                .padding()
                
                Divider()
                
                if bookRideVm.success {
                    
                    NavigationLink {
                        UserDetailsView(
                            firstName: bookRideVm.userResponse.user.firstName,
                            lastName: bookRideVm.userResponse.user.lastName,
                            dob: bookRideVm.userResponse.user.dob,
                            phoneNumber: bookRideVm.userResponse.user.phoneNumber,
                            phoneVerified: bookRideVm.userResponse.user.phoneVerified,
                            image: bookRideVm.userResponse.imageUrl,
                            averageRating: bookRideVm.userResponse.user.averageRating,
                            bio: bookRideVm.userResponse.user.bio)
                    } label: {
                        HStack {
                            
                            DriverProfile(
                                imageUrl: bookRideVm.userResponse.imageUrl,
                                name: bookRideVm.userResponse.user.firstName
                                + " " + bookRideVm.userResponse.user.lastName,
                                averageRating: bookRideVm.userResponse.user.averageRating)
                            
                            Spacer()
                            
                            Image(systemName: AppConstants.AppImages.chevronRight)
                        }
                        .padding()
                        .foregroundColor(.black)
                    }
                    
                    Divider()
                }
                
                if rideData.status == AppConstants.AppStrings.confirmBooking {
                    // Cancel Booking
                    Button {
                        bookRideVm.isPresented.toggle()
                    } label: {
                        Text(AppConstants.ButtonLabels.cancelBook)
                            .font(.headline)
                            .padding()
                    }
                    .onChange(of: bookRideVm.isSuccess) { _ in
                        if bookRideVm.isSuccess {
                            dismiss()
                        }
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle(AppConstants.AppHeadings.ridePlans)
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
        .onAppear {
            bookRideVm.getUserInfo(id: rideData.ride.userID)
        }
        .alert("Do you really want to cancel your booking?", isPresented: $bookRideVm.isPresented, actions: {
            Button(role: .destructive) {
                bookRideVm.cancelBooking(id: rideData.bookingId)
            } label: {
                Text(AppConstants.ButtonLabels.cancelBook)
            }
            
            Button(AppConstants.ButtonLabels.no, role: .cancel, action: {})
        })
        .alert("", isPresented: $bookRideVm.hasError, actions: {
            
            Button(AppConstants.ButtonLabels.ok, role: .cancel, action: {})
            
        }, message: {
            if let error = bookRideVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        })
        .alert("", isPresented: $bookRideVm.anyError, actions: {
            
            Button(AppConstants.ButtonLabels.ok, role: .cancel, action: {})
            
        }, message: {
            if let error = bookRideVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        })
    }
}

struct BookRideDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationStack {
            BookRideDetailsView(rideData: BookedRides.rides.rides[0])
        }
    }
}
