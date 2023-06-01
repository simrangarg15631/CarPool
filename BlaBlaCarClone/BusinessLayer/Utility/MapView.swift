//
//  MapView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 01/06/23.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    let region: MKCoordinateRegion
//    let lineCoordinates: [CLLocationCoordinate2D]
    let pathString: String
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        let lineCoordinates = polyLineWithEncodedString(encodedString: pathString)
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        mapView.addOverlay(polyline)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func polyLineWithEncodedString(encodedString: String) -> [CLLocationCoordinate2D] {
        var myRoutePoints = [CLLocationCoordinate2D]()
        let bytes = (encodedString as NSString).utf8String
        var idx: Int = 0
        var latitude: Double = 0
        var longitude: Double = 0
        while (idx < encodedString.lengthOfBytes(using: String.Encoding.utf8)) {
            var byte = 0
            var res = 0
            var shift = 0
            repeat {
                byte = Int(bytes![idx] - 63)
                idx += 1
                res |= (byte & 0x1F) << shift
                shift += 5
            } while (byte >= 0x20)
            let deltaLat = ((res & 1) != 0x0 ? ~(res >> 1) : (res >> 1))
            latitude += Double(deltaLat)

            shift = 0
            res = 0
            repeat {
                byte = Int(bytes![idx] - 63)
                idx += 1
                res |= (byte & 0x1F) << shift
                shift += 5
            } while (byte >= 0x20)
            let deltaLon = ((res & 1) != 0x0 ? ~(res >> 1) : (res >> 1))
            longitude += Double(deltaLon)

            myRoutePoints.append(CLLocation(latitude: Double(latitude * 1E-5), longitude: Double(longitude * 1E-5)).coordinate)
        }
        return myRoutePoints
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor(Color.accentColor)
            renderer.lineWidth = 8
            return renderer
        }
        return MKOverlayRenderer()
    }
    
}
