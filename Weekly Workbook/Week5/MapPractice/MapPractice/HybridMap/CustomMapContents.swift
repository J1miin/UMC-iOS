//
//  CustomMapContents.swift
//  MapPractice
//
//  Created by Apple Coding machine on 4/7/25.
//

import SwiftUI

struct CustomMapContents: View {
    
    @Bindable var locationManger =  LocationManager.shared
    
    var body: some View {
        CustomMap(locationManager: locationManger)
        
    }
}

#Preview {
    CustomMapContents()
}
