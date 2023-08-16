//
//  EditPublicationView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 08/06/23.
//

import SwiftUI

struct EditPublicationView: View {
    
    @StateObject var editPublishVm = EditPublicationViewModel()
    @Environment (\.dismiss) var dismiss
    
    var ride: PublishDetails
    @ObservedObject var detailsVm: DetailsViewModel
    
    var body: some View {
        
        List {
            if ride.status == AppConstants.AppStrings.pending {
                ForEach(Options.allCases, id: \.self) { option in
                    
                    NavigationLink {
                        switch option {
                        case .itinerary:
                            ItinearyView(editVm: editPublishVm, publishId: ride.id)
                        case .price:
                            PriceSelectionView(editVm: editPublishVm, publishId: ride.id)
                        case .seats:
                            SeatsOptionsView(editVm: editPublishVm, publishId: ride.id)
                        }
                    } label: {
                        Text(option.rawValue)
                            .font(.headline)
                            .opacity(0.9)
                    }
                    .listRowSeparator(.hidden)
                }
                
                Divider()
                
                Button {
                    editPublishVm.cancelPublish(id: ride.id)
                } label: {
                    Text(AppConstants.ButtonLabels.cancelRide)
                        .foregroundColor(.accentColor)
                        .font(.headline)
                }
                .listRowSeparator(.hidden)
                .onChange(of: editPublishVm.isSuccess) { _ in
                    self.dismiss()
                }
            }
            
            Button {
                
            } label: {
                Text(AppConstants.ButtonLabels.duplicateRide)
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
            .listRowSeparator(.hidden)

            Button {
                
            } label: {
                Text(AppConstants.ButtonLabels.publishReturn)
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
            .listRowSeparator(.hidden)
            
        }
        .padding(.top, 40)
        .listStyle(.plain)
        .navigationTitle(AppConstants.AppHeadings.editPublication)
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
        .alert("", isPresented: $editPublishVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = editPublishVm.errorMessage {
                Text(error.localizedDescription)
            }
        }
        .onAppear {
            
            if detailsVm.fromDetails {
                detailsVm.fromDetails = false
                editPublishVm.source = ride.source
                editPublishVm.destination = ride.destination
                
                editPublishVm.sourceCoord.latitude = ride.sourceLatitude
                editPublishVm.sourceCoord.longitude = ride.sourceLongitude
                
                editPublishVm.destCoord.latitude = ride.destinationLatitude
                editPublishVm.destCoord.longitude = ride.destinationLongitude
                
                editPublishVm.date = DateFormatterUtil.shared.dateFromString(
                    date: ride.date,
                    format: DateTimeFormat.yearMonthDate) ?? Date()
                
                editPublishVm.time = DateFormatterUtil.shared.dateFromString(
                    date: ride.time,
                    format: DateTimeFormat.hourMin) ?? Date()
                
                editPublishVm.price = Int(ride.setPrice)
                editPublishVm.aboutRide = ride.aboutRide ?? String()
                editPublishVm.seats = ride.passengersCount
            }
        }

    }
}

struct EditPublicationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditPublicationView(ride: PublishRideResponse.publishRideResponse.publish,
                                detailsVm: DetailsViewModel())
        }
    }
}
