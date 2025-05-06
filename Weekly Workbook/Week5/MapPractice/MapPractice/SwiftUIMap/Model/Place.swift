//
//  Place.swift
//  MapPractice
//
//  Created by Apple Coding machine on 4/10/25.
//

import Foundation
import MapKit

struct Place: Identifiable, Hashable {
    let id = UUID()
    let mapItem: MKMapItem
}
