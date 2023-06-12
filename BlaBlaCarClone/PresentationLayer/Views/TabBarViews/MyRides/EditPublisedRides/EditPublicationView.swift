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
    
    @Binding var ride: PublishDetails
    
    var body: some View {
        
        List {
//            if ride.status == AppConstants.AppStrings.pending {
                ForEach(Options.allCases, id: \.self) { option in
                    
                    NavigationLink {
                        switch option {
                        case .itinerary:
                            ItinearyView(editVm: editPublishVm, ride: $ride)
                        case .price:
                            PriceSelectionView(ride: ride)
                        case .seats:
                            SeatsOptionsView(ride: ride)
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
//            }
            
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

    }
}

struct EditPublicationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditPublicationView(ride: Binding.constant(PublishRideResponse.publishRideResponse.publish))
        }
    }
}
