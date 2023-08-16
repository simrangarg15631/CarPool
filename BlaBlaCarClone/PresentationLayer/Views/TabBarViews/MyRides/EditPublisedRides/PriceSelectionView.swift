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
            
            PriceSelectCOmponent(price: $editVm.price)
            
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
