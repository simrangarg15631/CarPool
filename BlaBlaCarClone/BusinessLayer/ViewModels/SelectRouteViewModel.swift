//
//  SelectRouteViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 01/06/23.
//

import Foundation
import MapKit
import Combine

class SelectRouteViewModel: ObservableObject {
    
    @Published var region = MKCoordinateRegion(
       // Apple Park
       center: CLLocationCoordinate2D(latitude: 37.334803, longitude: 70.008965),
       span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
     )
    
    @Published var pathString = "ufzbFfptgVWQIOEO?K@k@Mk@MOYE]DKFW@EAOJYPo@Li@Lw@@YHQLSRGJLZn@pA\\pARdAJnA?z@CdAIx@Mx@q@xB_AxAm@l@c@\\gBl@s@N_ABq@AeAQw@UcAq@aAcACDYj@ENCf@Bf@ERKTOLG@Q@"
    
    @Published var errorMessage: APIError?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isSuccess = false
    
    var publisher: AnyCancellable?
    let network = NetworkManager.shared
    
    
    func getPathString(originLat: String, originLon: String, destLat: String, destLon: String) {
        
        publisher = network.getRoute(originLat: originLat, originLon: originLon, destLat: destLat, destLon: destLon)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoading = false
                    self.hasError = true
                    self.errorMessage = error as? APIError
                    
                case .finished:
                    print("signup")
                    self.isLoading = false
                    self.hasError = false
                    self.isSuccess.toggle()
                }
            } receiveValue: { [weak self] data in
                self?.pathString = data
            }
    }
    
}
