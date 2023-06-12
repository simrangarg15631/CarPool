//
//  CarRideListView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 17/05/23.
//

import SwiftUI

struct CarRideListView: View {
    
    @ObservedObject var homeVm: BookRideViewModel
    @State private var isPresented: Bool = false
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            // NavigationView
            HStack(alignment: .top, spacing: 10) {
                
                // Back button
                ImageButton(image: AppConstants.AppImages.chevronleft) {
                    dismiss()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack(alignment: .top) {
                        
                        Text(homeVm.startlocation)
                            .font(.subheadline)
                        
                        Image(systemName: AppConstants.AppImages.arrow)
                            .font(.subheadline)
                        
                        Text(homeVm.destination)
                            .font(.subheadline)
                    }
                        
                    Text("\(homeVm.formatDate()), \(homeVm.noOfSeats) \(AppConstants.AppStrings.passenger)")
                            .font(.caption)
                    
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(Color.accentColor)
        
            if homeVm.searchRideResponse.message == nil {
                
                    HStack(spacing: 20) {
                        
                        Text(AppConstants.AppStrings.filter)
                            .font(.headline)
                        
                        Divider()
                        
                        Button {
                            homeVm.orderBy = AppConstants.AppStrings.orderByTime
                            homeVm.searchRide()
                        } label: {
                            Text(AppConstants.AppStrings.departure)
                                .font(.headline)
                                .foregroundColor(
                                    homeVm.orderBy == AppConstants.AppStrings.orderByTime ? .accentColor : .gray)
                        }
                        
                        Divider()
                        
                        Button {
                            homeVm.orderBy = AppConstants.AppStrings.orderByPrice
                            homeVm.searchRide()
                        } label: {
                            Text(AppConstants.AppStrings.price)
                                .font(.headline)
                                .foregroundColor(
                                    homeVm.orderBy == AppConstants.AppStrings.orderByPrice ? .accentColor : .gray)
                        }
                    }
                    .frame(height: 20)
                    .padding(.top, 10)
                    
                    Divider()
                
                if homeVm.isLoading {
                    ProgressView()
                }

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        ForEach(homeVm.searchRideResponse.data, id: \.publish.id) { ride in
                            NavigationLink {
                                RideDetailsView(ride: ride, homeVm: homeVm)
                            }label: {
                                CarRideCardView(ride: ride, seats: homeVm.noOfSeats)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding()
                }
                .padding()
            } else {
                Spacer()
                NoRides(size: UIScreen.main.bounds.width/1.2)
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        
        .alert("", isPresented: $homeVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = homeVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
        .onAppear {
            if homeVm.dismiss {
                self.dismiss()
            }
        }
        
    }
}

struct CarRideListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CarRideListView(homeVm: BookRideViewModel())
        }
    }
}
