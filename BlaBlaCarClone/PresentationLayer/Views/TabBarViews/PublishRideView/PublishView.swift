//
//  PublishView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 18/05/23.
//

import SwiftUI
import MapKit

struct PublishView: View {
    
    @StateObject var publishVm = PublishRideViewModel()
    @Binding var vehicles: [Vehicle]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Headingview(title: AppConstants.ButtonLabels.publishRide)
                .bold()
            
            HomeScreenComponent(
                title: publishVm.startlocation,
                image: AppConstants.AppImages.largeCircle,
                isPresented: $publishVm.isSearchPresented,
                type: .leavingFrom)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.top, 20)
            
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
                VStack(alignment: .leading) {
                    Text(AppConstants.AppStrings.selectVehicle)
                        .font(.subheadline)
                        .opacity(0.7)
                        .padding(.top, 20)

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
                                Text("Select")
                                    
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
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(.gray.opacity(0.8))
            }
            .frame(width: 160)
            
            Spacer()
            
            if publishVm.showButton() {
                Button {
                    publishVm.region = MKCoordinateRegion(center: publishVm.startCoordinates, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
                    publishVm.getPathString(
                        originLat: String(publishVm.startCoordinates.latitude),
                        originLon: String(publishVm.startCoordinates.longitude),
                        destLat: String(publishVm.destCoordinates.latitude),
                        destLon: String(publishVm.destCoordinates.longitude))
                } label: {
                    ButtonLabelView(buttonLabel: "Proceed")
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationDestination(isPresented: $publishVm.isSuccess, destination: {
            SelectRouteView(pathString: $publishVm.pathString, region: $publishVm.region)
        })
        // On click search location is presented
        .fullScreenCover(isPresented: $publishVm.isSearchPresented, content: {
            SearchLocationview(address: $publishVm.startlocation, coordinates: $publishVm.startCoordinates)
        })
        // On click search location is Presented
        .fullScreenCover(isPresented: $publishVm.destSearchPresented, content: {
            SearchLocationview(address: $publishVm.destination, coordinates: $publishVm.destCoordinates)
        })
        // On click seatsView is presented
        .fullScreenCover(isPresented: $publishVm.isSeatsPresented, content: {
            SeatsView(noOfSeats: $publishVm.noOfSeats)
        })
    }
}

struct PublishView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PublishView(vehicles: Binding.constant([Vehicle.vehicleResponse]))
        }
    }
}
