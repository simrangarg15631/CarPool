//  SelectRouteView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 01/06/23.

import SwiftUI

struct SelectRouteView: View {
    
    @ObservedObject var publishVm: PublishRideViewModel
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            MapView(source: publishVm.startCoordinates,
                    destination: publishVm.destCoordinates,
                    pathString: publishVm.pathString)
                .edgesIgnoringSafeArea(.horizontal)
            
            HStack {
                Text(AppConstants.AppStrings.totalDistance)
                    .font(.headline)
                
                Spacer()
                
                Text(publishVm.totalDistance)
                    .font(.headline)
            }
            .padding()
            
            HStack {
                Text(AppConstants.AppStrings.estimatedTime)
                    .font(.headline)
                
                Spacer()
                
                Text(publishVm.estimatedTime)
                    .font(.headline)
            }
            .padding(.horizontal)
            
            Button {
                publishVm.getPrice()
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.proceed)
                    .cornerRadius(12)
            }
            .frame(height: 100)
            .padding(.horizontal)
            .navigationDestination(isPresented: $publishVm.isPresented, destination: {
                PriceView(publishVm: publishVm)
            })
            
        }
        .navigationTitle(AppConstants.AppHeadings.rideDetails)
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
        .onAppear {
            if publishVm.dismiss {
                self.dismiss()
            }
        }
        
    }
}

struct SelectRouteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectRouteView(publishVm: PublishRideViewModel())
        }
    }
}
