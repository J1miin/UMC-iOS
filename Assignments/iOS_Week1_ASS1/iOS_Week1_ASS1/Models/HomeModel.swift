//
//  HomeModel.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 4/6/25.
//

import Foundation

struct CoffeeItem: Identifiable {
    var id: UUID
    var name: String
    var eName: String
    var price: Int
    var imageName: String
    var description: String
    var drinkType: [DrinkTemp] 
}

struct NewsItem: Identifiable {
    var id: UUID = UUID() 
    var title: String
    var description: String
    var imageName: String
}

struct DessertItem: Identifiable {
    var id: UUID = UUID()
    var name: String
    var imageName: String
}
