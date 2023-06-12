//
//  AddvehicleView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 29/05/23.
//

import SwiftUI

struct AddVehicleView: View {
    
    @StateObject var vehicleVm = AddVehicleViewModel()
    @Environment (\.dismiss) var dismiss
    @Binding var vehicles: [Vehicle]
    
    var body: some View {
        
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 20) {
                    
                    InputFieldView(
                        placeholder: AppConstants.AppStrings.country,
                        textInputAutocapitalization: .words,
                        textFieldValue: $vehicleVm.country)
                    
                    InputFieldView(
                        placeholder: AppConstants.AppStrings.licensePlate,
                        textInputAutocapitalization: .characters,
                        textFieldValue: $vehicleVm.number)
                    
                    InputFieldView(placeholder: AppConstants.AppStrings.brand,
                                   textInputAutocapitalization: .words,
                                   textFieldValue: $vehicleVm.brand)
                    
                    InputFieldView(placeholder: AppConstants.AppStrings.vehName,
                                   textInputAutocapitalization: .words,
                                   textFieldValue: $vehicleVm.name)
                    
                    InputFieldView(placeholder: AppConstants.AppStrings.vehType,
                                   textInputAutocapitalization: .words,
                                   textFieldValue: $vehicleVm.type)
                    
                    InputFieldView(placeholder: AppConstants.AppStrings.vehColor, textFieldValue: $vehicleVm.color)
                    
                    InputFieldView(placeholder: AppConstants.AppStrings.vehModel, textFieldValue: $vehicleVm.model)
                    
                }
            }
            
            if vehicleVm.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            if vehicleVm.showSave() {
                Button {
                    vehicleVm.addVehicle(data: VehicleData(
                        vehicle: VehicleInfo(country: vehicleVm.country,
                                             number: vehicleVm.number,
                                             brand: vehicleVm.brand,
                                             name: vehicleVm.name,
                                             type: vehicleVm.type,
                                             color: vehicleVm.color,
                                             model: Int(vehicleVm.model) ?? 0)))
                } label: {
                    ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.save)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
                .onChange(of: vehicleVm.isSuccess, perform: { _ in
                    if vehicleVm.isSuccess {
                        vehicles.append(vehicleVm.vehicleResponse)
                        self.dismiss()
                    }
                })
            }
        }
        .padding()
        .navigationTitle(AppConstants.AppHeadings.vehicleInfo)
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
        // Show alert if there is error in updating profile
        .alert("", isPresented: $vehicleVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = vehicleVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
        
    }
}

struct AddVehicleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddVehicleView(vehicles: Binding.constant([Vehicle.vehicleResponse]))
        }
    }
}
