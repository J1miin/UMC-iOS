//
//  CoffeeDetailViewModel.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 4/6/25.
//

import Foundation
import SwiftUI

class CoffeeDetailViewModel : ObservableObject{
    @Published var selectedCoffee :  CoffeeDetail? = nil

    func setSelectedCoffee(_ coffee: CoffeeDetail){
        selectedCoffee = coffee
    }
    
}
