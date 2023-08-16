//
//  CustomAnnotation.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 11/08/23.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class CustomAnnotationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        didSet {
            image = UIImage(named: "marker")
        }
    }
}
