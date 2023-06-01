//  EditProfileView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 23/05/23.

import SwiftUI

struct EditProfileView: View {
    
    @Environment (\.dismiss) var dismiss
    
    @StateObject var editVm = EditProfileViewModel()
    
    @Binding var userData: UserResponse
    
    var body: some View {
        
        VStack {
            
            ScrollView(showsIndicators: false) {
                
                LazyVStack(alignment: .leading, spacing: 20) {
                    
                    InputFieldView(placeholder: AppConstants.AppStrings.firstName,
                                   textInputAutocapitalization: .words,
                                   textFieldValue: $editVm.firstName)
                    
                    InputFieldView(placeholder: AppConstants.AppStrings.lastName,
                                   textInputAutocapitalization: .words,
                                   textFieldValue: $editVm.lastName)
                    
                    VStack(alignment: .leading) {
                        
                        Text(AppConstants.AppStrings.gender)
                            .font(.subheadline)
                        
                        Menu {
                            ForEach(editVm.genderType, id: \.self) { gender in
                                Button {
                                    editVm.gender = gender
                                } label: {
                                    Text(gender)
                                }
                            }
                        } label: {
                            
                            HStack {
                                Text(editVm.gender)
                                
                                Spacer()
                                
                                Image(systemName: AppConstants.AppImages.chevronDown)
                            }
                            .foregroundColor(.black)
                            .padding(12)
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading) {
                        
                        Text(AppConstants.AppStrings.dateOfBirth)
                            .font(.subheadline)
                        
                        HStack {
                            Text(editVm.myDate)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Image(systemName: AppConstants.AppImages.chevronDown)
                        }
                        .padding(14)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .onTapGesture {
                            editVm.showPicker.toggle()
                        }
                    }
                    
                    InputFieldView(placeholder: AppConstants.AppStrings.email,
                                   keyBoardType: .emailAddress,
                                   textFieldValue: $editVm.email)
                    
                    InputFieldView(placeholder: AppConstants.AppStrings.phoneNumber,
                                   keyBoardType: .phonePad,
                                   textFieldValue: $editVm.phone)
                    
                    InputFieldView(placeholder: AppConstants.AppStrings.bio,
                                   textFieldValue: $editVm.bio)
                }
                .padding(.bottom, 50)
            }
            
            if editVm.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            Button {
                // edit profile
                editVm.editInfo(data: UserData(user:
                UserDetails(email: editVm.email,
                            firstName: editVm.firstName,
                            lastName: editVm.lastName,
                            dob: editVm.myDate,
                            title: editVm.gender,
                            phoneNumber: Int(editVm.phone),
                            bio: editVm.bio)))
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.save)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
            .onChange(of: editVm.isSuccess, perform: { _ in
                if editVm.isSuccess {
                    self.dismiss()
                }
            })
        }
        .padding()
        .navigationTitle(AppConstants.AppHeadings.personalDetails)
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
        .sheet(isPresented: $editVm.showPicker) {
            PickerView(showPicker: $editVm.showPicker, shownDate: $editVm.dob, myDate: $editVm.myDate)
                .presentationDetents([.height(240)])
        }
        // Show alert if there is error in updating profile
        .alert("", isPresented: $editVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = editVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
        
        .onAppear {
            if let data = userData.status.data {
                editVm.firstName = data.firstName
                editVm.lastName = data.lastName
                editVm.gender = data.title
                editVm.myDate = data.dob
                editVm.email = data.email
                editVm.phone = data.phoneNumber ?? ""
                editVm.bio = data.bio ?? ""
            }
        }
        .onDisappear {
            if editVm.isSuccess {
                userData = editVm.userResponse
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditProfileView(userData: Binding.constant(UserResponse.userResponse))
        }
    }
}
