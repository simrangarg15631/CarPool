//
//  ProfileView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 18/05/23.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var profileVm = ProfileViewModel()
    @Binding var userData: UserResponse
    @Binding var vehicles: [Vehicle]
    @State private var deleteAlert: Bool = false
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            LazyVStack {
                
                // Image, Name, Age, Ratings
                LazyVStack {
                    
                    if let imageUrl = userData.status.imageUrl {
                        AsyncImage(url: imageUrl) { phase in
                            if let image = phase.image {
                                // Image from Api
                                image
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .padding(.top, 10)
                                
                             } else {
                                // Activity Indicator Till the icon is loading show
                                ProgressView()
                                    .frame(width: 120, height: 120)
                            }
                        }
                        
                    } else {
                        Image(systemName: AppConstants.AppImages.personCircle)
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    }
                    
                    if let data = userData.status.data {
                        
                        HStack {
                            
                            Text("\(data.firstName) \(data.lastName),")
                                .font(.headline)
                            
                            Text("\(DateFormatterUtil.shared.calculateAge(dob: data.dob))")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 5)
                        
                        HStack(spacing: 1) {
                            Text(String(format: "%.1f", data.averageRating ?? "0.0"))
                                .font(.subheadline)
                            Image(systemName: AppConstants.AppImages.star)
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                        .bold()
                        
                        // Edit Pic and details
                        LazyVStack(alignment: .leading, spacing: 20) {
                            
                            NavigationLink {
                                // Navigate to EditProfilePicView
                                EditProfilePicView(userData: $userData)
                            } label: {
                                Text(AppConstants.ButtonLabels.editprofilePic)
                                    .font(.subheadline)
                                    .bold()
                            }
                            
                            NavigationLink {
                                // Navigate to EditProfileView
                                EditProfileView(userData: $userData)
                            } label: {
                                Text(AppConstants.ButtonLabels.editProfile)
                                    .font(.subheadline)
                                    .bold()
                            }
                            
                            Divider()
                        }
                        .padding(.top)
                        
                        // About You
                        if let bio = data.bio, !bio.isEmpty {
                            LazyVStack(alignment: .leading, spacing: 10) {
                                
                                Text(AppConstants.AppStrings.aboutYou)
                                    .padding(.top, 10)
                                    .font(.headline)
                                
                                Text(bio)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                    .padding(.vertical, 10)
                                    .opacity(0.7)
                                    .bold()
                                
                                Divider()
                            }
                        }
                        
                        // Verify your profile
                        LazyVStack(alignment: .leading, spacing: 10) {
                            
                            Text(AppConstants.AppStrings.verifyYourProfile)
                                .padding(.top, 10)
                                .font(.headline)
                            
                            if data.activated != nil {
                                
                                ImageTitleView(
                                    title: data.email,
                                    image: AppConstants.AppImages.checkmarkCircle,
                                    color: .green)
                                .foregroundColor(.black.opacity(0.7))
                                .bold()
                                .padding(.top, 10)
                                
                            } else {
                                
                                NavigationLink {
                                    
                                } label: {
                                    ImageTitleView(
                                        title: AppConstants.ButtonLabels.confirmMyEmail + " " + data.email,
                                        image: AppConstants.AppImages.plus,
                                        color: .accentColor)
                                    .padding(.top, 10)
                                }
                            }
                            
                            if data.sessionKey != nil {
                                
                                if let phone = data.phoneNumber {
                                    ImageTitleView(
                                        title: phone,
                                        image: AppConstants.AppImages.checkmarkCircle,
                                        color: .green)
                                    .foregroundColor(.black.opacity(0.7))
                                    .bold()
                                    .padding(.vertical, 10)
                                }
                                
                            } else {
                                
                                NavigationLink {
                                    
                                } label: {
                                    if let phone = data.phoneNumber {
                                        ImageTitleView(
                                            title: AppConstants.ButtonLabels.confirmMyPhone + " " + phone,
                                            image: AppConstants.AppImages.plus,
                                            color: .accentColor)
                                        .padding(.vertical, 10)
                                    }
                                }
                            }
                            
                            Divider()
                        }
                        
                        // Vehicles
                        LazyVStack(alignment: .leading, spacing: 20) {
                            
                            Text(AppConstants.AppStrings.vehicles)
                                .font(.headline)
                                .padding(.top, 10)
                            
                            if !vehicles.isEmpty {
                                ForEach($vehicles, id: \.id) { $vehicle in
                                    
                                    NavigationLink {
                                        VehicleInfoView(vehicle: $vehicle)
                                    } label: {
                                        HStack {
                                            ImageTitleView(
                                                title: "\(vehicle.brand) \(vehicle.name) (\(vehicle.color))",
                                                image: AppConstants.AppImages.car, color: .black)
                                            .bold()
                                            .foregroundColor(.black)
                                            .opacity(0.6)
                                            
                                            Spacer()
                                            
                                            Image(systemName: AppConstants.AppImages.chevronRight)
                                                .foregroundColor(.black)
                                                .opacity(0.8)
                                        }
                                    }
                                }
                            }
                            
                            NavigationLink {
                                AddVehicleView(vehicles: $vehicles)
                            } label: {
                                ImageTitleView(
                                    title: AppConstants.ButtonLabels.addVehicle,
                                    image: AppConstants.AppImages.plus,
                                    color: .accentColor)
                            }
                            
                            Divider()
                        }
                        
                        // Member Since
                        LazyVStack(alignment: .leading, spacing: 20) {
                            
                            Text(AppConstants.AppStrings.memberSince
                                 + " " +
                                 DateFormatterUtil.shared.datetimeFormat(
                                    dateTime: data.createdAt,
                                    format: DateTimeFormat.monthYear)
                            )
                                .font(.subheadline)
                                .opacity(0.6)
                                .bold()
                                .padding(.top, 10)
                            
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.1))
                                .frame(height: 10)
                        }
                    }
                }
                
                LazyVStack(alignment: .leading, spacing: 15) {
                    
                    NavigationLink {
                        ChangePasswordView()
                    } label: {
                        ProfileRowView(title: AppConstants.AppStrings.changePassword)
                    }
                    
                    Divider()
                    
                    Button {
                        deleteAlert.toggle()
                    } label: {
                       Text(AppConstants.AppStrings.deleteAccount)
                            .foregroundColor(.red)
                    }
//                    .onChange(of: profileVm.success) { _ in
//                        NavigationUtil.popToRootView()
//                    }
                    
                    Divider()
                    
                    Button {
                        profileVm.signOut()
                    } label: {
                        Text(AppConstants.ButtonLabels.logOut)
                            .bold()
                    }
//                    .onChange(of: profileVm.isSuccess) { _ in
//                        NavigationUtil.popToRootView()
//                    }
                }
                .padding(.vertical)
            }
            .padding()
        }
        .navigationTitle(AppConstants.AppHeadings.profile)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .actionSheet(isPresented: $deleteAlert, content: {
            
            ActionSheet(
                title: Text(""),
                buttons: [
                    .destructive(Text(AppConstants.AppStrings.deleteAccount)) {
                        profileVm.deleteAccount()
                    },
                    .cancel()
                ])

        })
        // Show alert if there is error in updating profile
        .alert("", isPresented: $profileVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = profileVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
        .alert("", isPresented: $profileVm.anyError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = profileVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView(userData: Binding.constant(UserResponse.userResponse),
            vehicles: Binding.constant([Vehicle.vehicleResponse]))
        }
    }
}
