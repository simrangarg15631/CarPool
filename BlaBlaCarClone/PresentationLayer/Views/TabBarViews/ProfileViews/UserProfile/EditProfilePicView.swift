//
//  EditProfilePic.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 29/05/23.
//

import SwiftUI

struct EditProfilePicView: View {
    
    @Environment (\.dismiss) var dismiss
    @Binding var userData: UserResponse
    @StateObject var editPicVm = EditProfilePicViewModel()
    
    var body: some View {
        
        VStack {
            
            Headingview(title: AppConstants.AppHeadings.editProfilePic)
                .offset(y: -30)
            
            PhotoPickerView(profilePic: $editPicVm.profilePic)
            
            Spacer()
            
            if editPicVm.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            if let pic = editPicVm.profilePic {
                
                Button {
                    // api call to add image
                    editPicVm.addPic(image: pic)
                } label: {
                    ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.save)
                        .cornerRadius(18)
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
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
        .alert("", isPresented: $editPicVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = editPicVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
        .onChange(of: editPicVm.isSuccess, perform: { _ in
            if editPicVm.isSuccess {
                self.dismiss()
            }
        })
        .onDisappear {
            if editPicVm.isSuccess {
                userData = editPicVm.userResponse
            }
        }
    }
}

struct EditProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditProfilePicView(userData: Binding.constant(UserResponse.userResponse))
        }
    }
}
