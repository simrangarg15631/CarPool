//
//  DetailsView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 06/06/23.
//

import SwiftUI

struct DetailsView: View {
    
    @StateObject var detailsVm = DetailsViewModel()
    @Environment (\.dismiss) var dismiss
    var rideData: PublishDetails
    
    var body: some View {
        
        List {
            
            Text(detailsVm.rideData.status.capitalized)
                .font(.headline)
                .foregroundColor(.gray)
                .bold()
                .listRowSeparator(.hidden)
            
            // Trip Info
            VStack(alignment: .leading, spacing: 12) {
                
                Text(AppConstants.AppHeadings.tripInfo)
                    .font(.headline)
                    .padding(.bottom)
                
                DetailView(
                    image: AppConstants.AppImages.calendar,
                    text: detailsVm.rideData.date)
                
                if let route = detailsVm.rideData.selectRoute?.routes {
                    if !route.isEmpty {
                        
                        DetailView(
                            image: AppConstants.AppImages.clock,
                            text: route[0].legs[0].duration.text)
                        
                        DetailView(
                            image: AppConstants.AppImages.distance,
                            text: route[0].legs[0].distance.text)
                    }
                }
            }
            .padding(.vertical)
            .listRowSeparator(.hidden, edges: .top)
            
            // PickUp drop location
            HStack(spacing: 16) {
                
                CustomShape()
                    .stroke(Color.black, lineWidth: 1)
                    .frame(maxWidth: 10)
                    .padding(.bottom, 25)
                
                VStack(alignment: .leading) {
                    
                    RideDetailComponent(
                        title: detailsVm.rideData.source,
                        time: DateFormatterUtil.shared.datetimeFormat(
                            dateTime: detailsVm.rideData.time,
                            format: DateTimeFormat.hourMin))
                    .padding(.bottom)
                    
                    RideDetailComponent(
                        title: detailsVm.rideData.destination,
                        time: "")
                    .padding(.top)
                }
            }
            .padding(.top)
            
            HStack {
                Text(AppConstants.AppStrings.pricePerSeat)
                    .font(.headline)
                    .opacity(0.7)
                
                Spacer()
                
                Text("Rs. \(String(format: "%0.2f", detailsVm.rideData.setPrice))")
            }
            .padding(.vertical)
            
            if detailsVm.isLoading {
                HStack {
                    Spacer()
                    
                    ProgressView()
                        .padding(.vertical)
                    
                    Spacer()
                }
            } else {
                if detailsVm.passengersArray.isEmpty {
                    Text(AppConstants.AppStrings.noPassengers)
                        .font(.subheadline)
                        .bold()
                        .opacity(0.9)
                        .padding(.vertical)
                } else {
                    ForEach(detailsVm.passengersArray, id: \.userId) { passenger in
                        NavigationLink {
                            UserDetailsView(
                                firstName: passenger.firstName,
                                lastName: passenger.lastName,
                                dob: passenger.dob,
                                phoneNumber: passenger.phoneNumber,
                                phoneVerified: passenger.phoneVerified,
                                image: passenger.image,
                                averageRating: passenger.averageRating,
                                bio: passenger.bio,
                                seats: passenger.seats)
                        } label: {
                            DriverProfile(imageUrl: passenger.image,
                                          name:
                                            passenger.firstName +
                                          passenger.lastName,
                                          averageRating: passenger.averageRating)
                            .padding(.top)
                            .foregroundColor(.black)
                        }
                    }
                }
            }
            
            NavigationLink {
                EditPublicationView(ride: detailsVm.rideData, detailsVm: detailsVm)
            } label: {
                Text(AppConstants.AppStrings.editPublication)
            }
            .padding(.vertical)
            
        }
        .listStyle(.plain)
        .navigationTitle(AppConstants.AppHeadings.ridePlans)
        .navigationBarTitleDisplayMode(.large)
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
            detailsVm.fromDetails = true
            detailsVm.getPassengersInfo(publishId: rideData.id)
        }
        .alert("", isPresented: $detailsVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel, action: {})
        } message: {
            if let error = detailsVm.errorMessage {
                Text(error.localizedDescription)
            }
        }

    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailsView(rideData: PublishRideResponse.publishRideResponse.publish)
        }
    }
}
