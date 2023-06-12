//
//  ItinearyView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 08/06/23.
//

import SwiftUI

struct ItinearyView: View {
    
    @ObservedObject var editVm: EditPublicationViewModel
    @Environment (\.dismiss) var dismiss
    @Binding var ride: PublishDetails
    
    var body: some View {
        
        VStack {
            
            DatePicker(selection: $editVm.date, in: Date()..., displayedComponents: .date, label: {
                
                    Text(AppConstants.AppStrings.date)
                        .font(.headline)
            })
            .padding(.top)
            
            DatePicker(selection: $editVm.time, in: Date()..., displayedComponents: .hourAndMinute, label: {
                
                    Text(AppConstants.AppStrings.time)
                        .font(.headline)
            })
            .padding(.top)
            
            // PickUp drop location
            HStack(alignment: .top, spacing: 16) {
                
                CustomShape()
                    .stroke(Color.black, lineWidth: 1)
                    .frame(maxWidth: 10)
                    .padding(.bottom, 25)
                
                VStack(alignment: .leading) {
                    
                    Button {
                        editVm.srcPresent = true
                    } label: {
                        
                        HStack(alignment: .firstTextBaseline) {
                            
                            RideDetailComponent(
                                title: editVm.source,
                                time: "")
                            .padding(.bottom)
                            
                            Spacer()
                            
                            Image(systemName: AppConstants.AppImages.chevronRight)
                                .foregroundColor(.gray)
                        }
                        
                    }
                    
                    Button {
                        editVm.destPresent = true
                    } label: {
                        
                        HStack(alignment: .firstTextBaseline) {
                            
                            RideDetailComponent(
                                title: editVm.destination,
                                time: "")
                            .padding(.top)
                            
                            Spacer()
                            
                            Image(systemName: AppConstants.AppImages.chevronRight)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(.top, 30)
            .frame(height: 145)
            
            Spacer()
            
            Button {
//                editVm.editPublication(id: ride.id, data: UpdateData(source: editVm.source,
//                            destination: editVm.destination,
//                            sourceLongitude: editVm.sourceCoord.longitude,
//                            sourceLatitude: editVm.sourceCoord.latitude,
//                            destinationLongitude: editVm.destCoord.longitude,
//                            destinationLatitude: editVm.destCoord.latitude,
//                                                                     date: DateFormatterUtil.shared.formatDate(date: editVm.date), time: <#T##String?#>))
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.save)
                    .cornerRadius(12)
            }
            
        }
        .padding()
        .navigationTitle(AppConstants.AppHeadings.itineraryDetails)
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
            
            editVm.date = DateFormatterUtil.shared.dateFromString(
                date: ride.date,
                format: AppConstants.DateTimeFormat.yearMonthDate) ?? Date()
            
            editVm.time = DateFormatterUtil.shared.dateFromString(
                date: ride.time,
                format: AppConstants.DateTimeFormat.hourMin) ?? Date()
            
            editVm.source = ride.source
            editVm.sourceCoord.latitude = ride.sourceLatitude
            editVm.sourceCoord.longitude = ride.sourceLongitude
            
            editVm.destination = ride.destination
            editVm.destCoord.latitude = ride.destinationLatitude
            editVm.destCoord.longitude = ride.destinationLongitude
        }
        .fullScreenCover(isPresented: $editVm.srcPresent, content: {
            SearchLocationview(address: $editVm.source,
                               coordinates: $editVm.sourceCoord)
        })
        .fullScreenCover(isPresented: $editVm.destPresent) {
            SearchLocationview(address: $editVm.destination,
                               coordinates: $editVm.destCoord)
        }
        
    }
}

struct ItinearyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ItinearyView(editVm: EditPublicationViewModel(),
                         ride: Binding.constant(PublishRideResponse.publishRideResponse.publish))
        }
    }
}
