//
//  Marker.swift
//  MapPractice
//
//  Created by Apple Coding machine on 4/5/25.
//

import Foundation
import MapKit

struct Marker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}
