//
//  PhotoPickerView+.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 23/05/23.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    
    // MARK: - Properties
    @StateObject var imagePicker = PhotosPickerViewModel()
    @Binding var profilePic: Data?
    var imageURL: URL?
    
    var body: some View {
        
        // MARK: - Photo Picker
        PhotosPicker(
            selection: $imagePicker.imageSelection,
            matching: .images
        ) {
            if let image = imagePicker.image {
                VStack(spacing: 12) {
                    image
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding(.top, 15)
                    
                    Text(AppConstants.ButtonLabels.editPhoto)
                        .bold()
                }
                
            } else {
                VStack(spacing: 12) {
                    if let imageURL {
                        AsyncImage(url: imageURL) { phase in
                            if let image = phase.image {
                                // Image from Api
                                image
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .padding(.top, 15)
                                
                             } else {
                                // Activity Indicator Till the icon is loading show
                                ProgressView()
                                    .frame(width: 150, height: 150)
                            }
                        }
                        
                        Text(AppConstants.ButtonLabels.editPhoto)
                            .bold()
                    } else {
                        Image(systemName: AppConstants.AppImages.personCircle)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray)
                            .padding(.top, 15)
                        
                        Text(AppConstants.ButtonLabels.addPhoto)
                            .bold()
                    }
                        
                }
            }
        }
        .onChange(of: imagePicker.image, perform: { _ in
            if let data = imagePicker.data {
                profilePic = data
            }
        })
    }
    
}

struct PhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView(profilePic: Binding.constant(Data()))
    }
}
