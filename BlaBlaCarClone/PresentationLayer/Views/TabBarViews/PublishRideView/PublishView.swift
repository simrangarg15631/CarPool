//
//  PublishView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 18/05/23.
//

import SwiftUI

struct PublishView: View {
    
    @StateObject var publishVm = PublishRideViewModel()
    @Binding var vehicles: [Vehicle]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Headingview(title: AppConstants.ButtonLabels.publishRide)
                .bold()
            
            // Leaving From
            HomeScreenComponent(
                title: publishVm.startlocation,
                image: AppConstants.AppImages.largeCircle,
                isPresented: $publishVm.isSearchPresented,
                type: .leavingFrom)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.top, 20)
            
            // Going to
            HomeScreenComponent(
                title: publishVm.destination,
                image: AppConstants.AppImages.largeCircle,
                isPresented: $publishVm.destSearchPresented,
                type: .goingTo)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.top, 20)
            
            DatePicker(selection: $publishVm.date, label: {
                Text(AppConstants.AppStrings.dateAndTime)
                    .font(.subheadline)
                    .opacity(0.7)
            })
            .padding(.top, 20)
            
            HStack(spacing: 50) {
                
                // Select a vehicle
                VStack(alignment: .leading) {
                    Text(AppConstants.AppStrings.selectVehicle)
                        .font(.subheadline)
                        .opacity(0.7)
                        .padding(.top, 20)
                    
                    if !vehicles.isEmpty {
                        
                        Menu {
                            ForEach(vehicles, id: \.id) { vehicle in
                                Button {
                                    publishVm.vehicle = vehicle
                                } label: {
                                    Text(vehicle.brand + vehicle.name)
                                        .padding()
                                }
                            }
                        } label: {
                            if let vehicle = publishVm.vehicle {
                                HStack {
                                    Text(vehicle.name)
                                    
                                    Spacer()
                                    
                                    Image(systemName: AppConstants.AppImages.chevronDown)
                                }
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .padding(.top, 8)
                            } else {
                                HStack {
                                    Text(AppConstants.AppStrings.select)
                                    
                                    Spacer()
                                    
                                    Image(systemName: AppConstants.AppImages.chevronDown)
                                }
                                .font(.subheadline)
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.top, 8)
                            }
                        }
                        
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 1)
                            .foregroundColor(.gray.opacity(0.8))
                    } else {
                        
                        NavigationLink {
                            AddVehicleView(vehicles: $vehicles)
                        } label: {
                            ImageTitleView(
                                title: AppConstants.ButtonLabels.addVehicle,
                                image: AppConstants.AppImages.plus,
                                color: .accentColor)
                            .padding(.top, 15)
                        }
                    }
                }
                
                PublishRowComponent(
                    title: AppConstants.AppStrings.availableSeats,
                    subTitle: String(publishVm.noOfSeats),
                    isPresented: $publishVm.isSeatsPresented)
            }
            
            VStack(alignment: .leading) {
                Text(AppConstants.AppStrings.priceSeat)
                    .font(.subheadline)
                    .opacity(0.7)
                    .padding(.top, 20)
                
                TextField(AppConstants.AppStrings.rs, text: $publishVm.price)
                    .padding(.top, 8)
                    .keyboardType(.numberPad)
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(.gray.opacity(0.8))
            }
            .frame(width: 160)
            
            Spacer()
            
            if publishVm.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding(.bottom, 20)
                    Spacer()
                }
            }
            
            if publishVm.showButton() {
                
                Button {
                    publishVm.setRegion()
                    
                    publishVm.getPathString(
                        originLat: String(publishVm.startCoordinates.latitude),
                        originLon: String(publishVm.startCoordinates.longitude),
                        destLat: String(publishVm.destCoordinates.latitude),
                        destLon: String(publishVm.destCoordinates.longitude))
                } label: {
                    ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.proceed)
                        .cornerRadius(10)
                }
                .padding(.bottom, 30)
            }
        }
        .padding()
        .navigationDestination(isPresented: $publishVm.isSuccess, destination: {
            SelectRouteView(publishVm: publishVm)
        })
        // On Tap of leaving From Search location page is presented
        .fullScreenCover(isPresented: $publishVm.isSearchPresented, content: {
            SearchLocationview(address: $publishVm.startlocation, coordinates: $publishVm.startCoordinates)
        })
        // On click of Going to search location is Presented
        .fullScreenCover(isPresented: $publishVm.destSearchPresented, content: {
            SearchLocationview(address: $publishVm.destination, coordinates: $publishVm.destCoordinates)
        })
        // On click of Available Seats SeatsView is presented
        .fullScreenCover(isPresented: $publishVm.isSeatsPresented, content: {
            SeatsView(noOfSeats: $publishVm.noOfSeats)
        })
        .onAppear {
            
            if publishVm.dismiss {
                publishVm.startlocation = String()
                publishVm.destination = String()
                publishVm.date = Date()
                publishVm.vehicle = nil
                publishVm.noOfSeats = 1
                publishVm.price = String()
            }
            publishVm.dismiss = false
            
        }
    }
}

struct PublishView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PublishView(vehicles: Binding.constant([Vehicle.vehicleResponse]))
        }
    }
}
