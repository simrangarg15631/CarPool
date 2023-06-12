//
//  TabBarView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 18/05/23.
//

import SwiftUI

struct TabBarView: View {
    
    @StateObject var tabVm = TabBarViewModel()
    var body: some View {
        
        TabView {
            
            BookRideView()
                .tabItem {
                    Label(AppConstants.ButtonLabels.search, systemImage: AppConstants.AppImages.magnifyingGlass)
                }
            
            PublishView(vehicles: $tabVm.vehicleResponse)
                .tabItem {
                    Label(AppConstants.ButtonLabels.publish, systemImage: AppConstants.AppImages.publish)
                }
            
            MyRidesView()
                .tabItem {
                    Label(AppConstants.ButtonLabels.myRides, systemImage: AppConstants.AppImages.car)
                }

            InboxView()
                .tabItem {
                    Label(AppConstants.ButtonLabels.inbox, systemImage: AppConstants.AppImages.message)
                }
            
            ProfileView(userData: $tabVm.userResponse, vehicles: $tabVm.vehicleResponse)
                .tabItem {
                    Label(AppConstants.ButtonLabels.profile, systemImage: AppConstants.AppImages.profile)
                        
                }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            
            if tabVm.isFirst {
                tabVm.getUser()
                tabVm.getAllVehicles()
            }
        }
        .onDisappear {
            tabVm.isFirst = false
        }
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
