//
//  SeatsOptionsView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/06/23.
//

import SwiftUI

struct SeatsOptionsView: View {
    
    @Environment (\.dismiss) var dismiss
    @ObservedObject var editVm: EditPublicationViewModel
    var publishId: Int
    
    var body: some View {
        
        VStack {
            
            HStack {
                ImageButton(image: AppConstants.AppImages.chevronleft) {
                    self.dismiss()
                }
                .font(.headline)
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(Color.accentColor)
            
            HStack(spacing: 20) {
                
                Text(AppConstants.AppStrings.coTravellers)
                
                Spacer()
                
                ImageButton(image: AppConstants.AppImages.minus) {
                    editVm.seats -= 1
                }
                .disabled(editVm.seats == 1)

                Text("\(editVm.seats)")
                
                ImageButton(image: AppConstants.AppImages.plus) {
                    editVm.seats += 1
                }
                .disabled(editVm.seats == 8)
                
            }
            .font(.title2)
            .fontWeight(.semibold)
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 14) {
                Text(AppConstants.AppStrings.rideDetails)
                    .font(.headline)
                
                Text(AppConstants.AppStrings.forExample)
                    .font(.caption)
                
                VStack(alignment: .leading) {
                    
                    Text(AppConstants.AppStrings.type100)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextEditor(text: $editVm.aboutRide)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 140)
                .scrollContentBackground(.hidden)
                .background(Color.gray.opacity(0.1))
                .padding(.top, 10)
            }
            .padding()
            .padding(.top, 20)
            
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
            .padding()
            .onChange(of: editVm.success, perform: { newValue in
                if newValue {
                    self.dismiss()
                }
            })
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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

struct SeatsOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SeatsOptionsView(editVm: EditPublicationViewModel(),
                         publishId: 0)
    }
}
