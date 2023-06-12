//
//  MyRidesView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 06/06/23.
//

import SwiftUI

struct MyRidesView: View {
    
    @StateObject var myRidesVm = MyRidesViewModel()
    @Namespace var animation
    
    var body: some View {
        
        VStack {
            
            if !myRidesVm.publishedRides.isEmpty || !myRidesVm.bookedRides.isEmpty {

                VStack {
                    
                    headingView
                    
                    filterBar
                    
                    if myRidesVm.selected == AppConstants.AppStrings.booked {
                        
                        if !myRidesVm.bookedRides.isEmpty {
                            
                            booked
                            
                        } else {
                            NoRidesView(title: AppConstants.AppStrings.noRidesBooked)
                        }
                        
                    } else if myRidesVm.selected == AppConstants.AppStrings.published {
                        
                        if !myRidesVm.publishedRides.isEmpty {
                            
                            published
                            
                        } else {
                            NoRidesView(title: AppConstants.AppStrings.noRidesPublished)
                        }
                    }
                }
                .padding()
                
            } else {
                FutureTravelView()
            }
        }
        .onAppear {
            myRidesVm.getAllPublishedRides()
            myRidesVm.getAllBookedRides()
        }
        .alert("", isPresented: $myRidesVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = myRidesVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
    }
}

struct MyRidesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyRidesView()
        }
    }
}

extension MyRidesView {
    
    var headingView: some View {
        
        HStack {
            
            Text(AppConstants.AppHeadings.myRides)
                .font(.largeTitle)
                .bold()
                .padding()
            
            Spacer()
        }
    }
    
    var filterBar: some View {
        
        // Filterbar
        HStack {
            ForEach(myRidesVm.array, id: \.self) { item in
                
                VStack {
                    Text(item)
                        .font(.subheadline)
                        .fontWeight(myRidesVm.selected == item ? .semibold : .regular)
                        .foregroundColor(myRidesVm.selected == item ? .black : .gray)
                    
                    // Underline Capsule
                    if myRidesVm.selected == item {
                        Capsule()
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: 2)
                        // slidingEffect of capsule
                            .matchedGeometryEffect(id: "filter", in: animation)
                    } else {
                        Capsule()
                            .foregroundColor(Color(.clear))
                            .frame(height: 2)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        myRidesVm.selected = item
                    }
                }
            }
        }
        .overlay {
            Divider()
                .offset(x: 0, y: 16)
        }
        .padding(.top)
    }
    
    var booked: some View {
        
        List {
            ForEach(myRidesVm.bookedRides, id: \.bookingId) { ride in
                
                ZStack {
                    
                    NavigationLink {
                        BookRideDetailsView(rideData: ride)
                    }label: {
                        EmptyView()
                    }
                    
                    MyRidesCardView(published: false,
                                    rideData: ride.ride,
                                    seats: ride.seat,
                                    status: ride.status)
                }
                .padding(.vertical, 8)
                .listRowSeparator(.hidden)
            }
            
        }
        .listStyle(.plain)
        .refreshable {
            myRidesVm.getAllBookedRides()
        }
    }
    
    var published: some View {
        
        List {
            
            ForEach(myRidesVm.publishedRides, id: \.id) { ride in
                
                ZStack {
                    
                    NavigationLink {
                        DetailsView(rideData: ride)
                    } label: {
                        EmptyView()
                    }

                    MyRidesCardView(published: true, rideData: ride)

                }
                .padding(.vertical, 8)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .refreshable {
            myRidesVm.getAllPublishedRides()
        }

    }
    
}
