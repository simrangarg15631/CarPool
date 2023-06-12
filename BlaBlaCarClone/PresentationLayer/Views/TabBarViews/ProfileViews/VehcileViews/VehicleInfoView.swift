//
//  EditVehicleView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 29/05/23.
//

import SwiftUI

struct VehicleInfoView: View {
    
    @StateObject var vehicleVm = VehicleInfoViewModel()
    @Environment (\.dismiss) var dismiss
    @Binding var vehicle: Vehicle
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            VStack(alignment: .leading, spacing: 20) {
                VehicleRow(title1: AppConstants.AppStrings.vehName,
                           title2: vehicle.name)
                
                VehicleRow(title1: AppConstants.AppStrings.brand,
                           title2: vehicle.brand)
                
                VehicleRow(title1: AppConstants.AppStrings.vehType,
                           title2: vehicle.type)
                
                VehicleRow(title1: AppConstants.AppStrings.vehColor,
                           title2: vehicle.color)
                
                VehicleRow(title1: AppConstants.AppStrings.licensePlate,
                           title2: vehicle.number)
                
                VehicleRow(title1: AppConstants.AppStrings.vehModel,
                           title2: String(vehicle.model))
                
                VehicleRow(title1: AppConstants.AppStrings.country,
                           title2: vehicle.country)
            }
            
            Rectangle()
                .foregroundColor(.gray.opacity(0.1))
                .frame(height: 10)
            
            NavigationLink {
                EditVehicleView(vehicle: $vehicle)
            } label: {
                Text(AppConstants.ButtonLabels.editVehicle)
                    .font(.headline)
            }
            
            Button {
                vehicleVm.isPresented.toggle()
            } label: {
                Text(AppConstants.ButtonLabels.deleteVehicle)
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .onChange(of: vehicleVm.isSuccess, perform: { _ in
                if vehicleVm.isSuccess {
                    self.dismiss()
                }
            })

            Spacer()
            
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
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
        .alert(AppConstants.AppStrings.deleteAlert, isPresented: $vehicleVm.isPresented) {
            
            Button(AppConstants.ButtonLabels.deleteVehicle, role: .destructive) {
                vehicleVm.deleteVehicle(vehicleId: vehicle.id)
            }
        }
    }
}

struct VehicleInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VehicleInfoView(vehicle: Binding.constant(Vehicle.vehicleResponse))
        }
    }
}
