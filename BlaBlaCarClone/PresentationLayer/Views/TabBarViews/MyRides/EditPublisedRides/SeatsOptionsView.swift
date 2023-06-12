//
//  SeatsOptionsView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/06/23.
//

import SwiftUI

struct SeatsOptionsView: View {
    
    @Environment (\.dismiss) var dismiss
    @State private var seatsCount = 1
    @State private var aboutRide = String()
    var ride: PublishDetails
    
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
                    seatsCount -= 1
                }
                .disabled(seatsCount == 1)

                Text("\(seatsCount)")
                
                ImageButton(image: AppConstants.AppImages.plus) {
                    seatsCount += 1
                }
                .disabled(seatsCount == 8)
                
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
                    
                    TextEditor(text: $aboutRide)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 140)
                .scrollContentBackground(.hidden)
                .background(Color.gray.opacity(0.1))
                .padding(.top, 10)
            }
            .padding()
            .padding(.top, 20)
            
            Spacer()
            
            Button {
                
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.save)
                    .cornerRadius(12)
            }
            .padding()

            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            seatsCount = ride.passengersCount
        }
    }
}

struct SeatsOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SeatsOptionsView(ride: PublishRideResponse.publishRideResponse.publish)
    }
}
