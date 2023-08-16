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
    var publishId: Int
    
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
            
            if editVm.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            Button {
                
                editVm.editPublication(id: publishId)
                
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.save)
                    .cornerRadius(12)
            }
            .onChange(of: editVm.success) { newValue in
                if newValue {
                    self.dismiss()
                }
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
        .fullScreenCover(isPresented: $editVm.srcPresent, content: {
            SearchLocationview(address: $editVm.source,
                               coordinates: $editVm.sourceCoord)
        })
        .fullScreenCover(isPresented: $editVm.destPresent) {
            SearchLocationview(address: $editVm.destination,
                               coordinates: $editVm.destCoord)
        }
        .onAppear {
            editVm.success = false
        }
        .alert("", isPresented: $editVm.anyError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}

        } message: {
            if let error = editVm.errorMessage {
                Text(error.localizedDescription)
            }
        }
    }
}

struct ItinearyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ItinearyView(editVm: EditPublicationViewModel(),
                         publishId: 0)
        }
    }
}
