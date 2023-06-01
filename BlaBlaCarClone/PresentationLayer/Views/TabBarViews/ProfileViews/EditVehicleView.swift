//
//  EditVehicleView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 31/05/23.
//

import SwiftUI

struct EditVehicleView: View {
    
    @StateObject var vehicleVm = EditVehicleViewModel()
    @Environment (\.dismiss) var dismiss
    @Binding var vehicle: Vehicle
    
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
                    vehicleVm.editVehicle(
                        vehicleId: vehicle.id,
                        data: VehicleData(
                            vehicle: VehicleInfo(
                                country: vehicleVm.country,
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
                        vehicle = vehicleVm.vehicleResponse
                        self.dismiss()
                    }
                })
            }
        }
        .padding()
        .navigationTitle(AppConstants.AppHeadings.editVehicle)
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
        .onAppear {
            vehicleVm.country = vehicle.country
            vehicleVm.number = vehicle.number
            vehicleVm.brand = vehicle.brand
            vehicleVm.name = vehicle.name
            vehicleVm.type = vehicle.type
            vehicleVm.color = vehicle.color
            vehicleVm.model = String(vehicle.model)
        }
            
    }
}

struct EditVehicleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditVehicleView(vehicle: Binding.constant(Vehicle.vehicleResponse))
        }
    }
}
