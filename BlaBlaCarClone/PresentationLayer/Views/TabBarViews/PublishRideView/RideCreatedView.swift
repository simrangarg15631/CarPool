//
//  RideCreatedView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 29/05/23.
//

import SwiftUI

struct RideCreatedView: View {
    
    @State private var aboutRide = String()
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Spacer()
                VStack {
                    Image(systemName: AppConstants.AppImages.checkmarkCircle)
                        .font(.system(size: 64))
                        .foregroundColor(.blue)
                    
                    Text(AppConstants.AppStrings.rideCreated)
                        .font(.headline)
                        .padding(.top, 10)
                }
                
                Spacer()
            }
            
            Text(AppConstants.AppStrings.addAboutRide)
                .font(.headline)
                .padding(.top, 44)
            
            Text(AppConstants.AppStrings.forExample)
                .font(.caption)
            
            TextEditor(text: $aboutRide)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 140)
                .scrollContentBackground(.hidden)
                .background(Color.gray.opacity(0.1))
                .padding(.top, 20)
            
            Spacer()
            
            Button {
                
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.publishRide)
                    .cornerRadius(12)
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
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
    }
}

struct RideCreatedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RideCreatedView()
        }
    }
}
