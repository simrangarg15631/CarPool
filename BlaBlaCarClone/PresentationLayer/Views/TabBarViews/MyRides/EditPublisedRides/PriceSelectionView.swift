//
//  PlaceSelectionView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/06/23.
//

import SwiftUI

struct PriceSelectionView: View {
    
    @Environment (\.dismiss) var dismiss
    @ObservedObject var editVm: EditPublicationViewModel
    var publishId: Int
    
    var body: some View {
        
        VStack {
            
            HStack {
                ImageButton(image: AppConstants.AppImages.minus) {
                    editVm.price -= 10
                }
                .font(.largeTitle)
                .disabled(editVm.price == 70)
                
                Spacer()
                
                Text("Rs. \(editVm.price)")
                    .font(.system(size: 42))
                    .bold()
                    .foregroundColor(editVm.price > 130 ? .red : .green)
                
                Spacer()
                
                ImageButton(image: AppConstants.AppImages.plus) {
                    editVm.price += 10
                }
                .font(.largeTitle)
                .disabled(editVm.price == 160)
            }
            .padding(.top, 50)
            
            if editVm.price > 130 {
                
                HStack {
                    
                    Image(systemName: AppConstants.AppImages.exclamation)
                    Text(AppConstants.AppStrings.maxPriceLimit)
                }
                .padding(.top, 8)
                .font(.subheadline)
                .fontWeight(.medium)
            }
            
            Spacer()
            
            if editVm.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            Button {
                editVm.editPublication(id: publishId, data: UpdateData(
                    source: editVm.source,
                    destination: editVm.destination,
                    sourceLongitude: editVm.sourceCoord.longitude,
                    sourceLatitude: editVm.sourceCoord.latitude,
                    destinationLongitude: editVm.destCoord.longitude,
                    destinationLatitude: editVm.destCoord.latitude,
                    passengersCount: editVm.seats,
                    date: DateFormatterUtil.shared.formatDate(date: editVm.date),
                    time: DateFormatterUtil.shared.formatDate(date: editVm.time, format: DateTimeFormat.hourMin),
                    setPrice: Double(editVm.price),
                    aboutRide: editVm.aboutRide))
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.save)
                    .cornerRadius(12)
            }
            .onChange(of: editVm.success, perform: { newValue in
                if newValue {
                    self.dismiss()
                }
            })

        }
        .padding()
        .navigationTitle(AppConstants.AppHeadings.editPrice)
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
        .alert("", isPresented: $editVm.anyError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}

        } message: {
            if let error = editVm.errorMessage {
                Text(error.localizedDescription)
            }
        }
        .onAppear {
            editVm.success = false
        }
    }
}

struct PriceSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PriceSelectionView(editVm: EditPublicationViewModel(),
                               publishId: 0)
        }
    }
}
