//
//  CoffeeDetailModel.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 4/6/25.
//

import Foundation

struct CoffeeDetail : Identifiable {
    var id : UUID = UUID()
    var kName : String
    var eName : String
    var description : String
    var price : Int
    var imgName : String
    var drinkType : [DrinkTemp]
}

enum DrinkTemp: String, CaseIterable, Hashable {
    case hot = "HOT"
    case iced = "ICED"
    
    // 문자열을 [DrinkTemp] 배열로 변환
    static func from(string: String) -> [DrinkTemp] {
        switch string.lowercased() {
        case "hot":
            return [.hot]
        case "iced", "ice":
            return [.iced]
        case "both":
            return [.hot, .iced]
        default:
            return []
        }
    }
    
    // 표시용 텍스트
    var displayText: String {
        switch self {
        case .hot:
            return "HOT ONLY"
        case .iced:
            return "ICE ONLY"
        }
    }
}

extension CoffeeDetail {
    init(from item: CoffeeItem) {
        self.kName = item.name
        self.eName = item.eName
        self.description = item.description
        self.price = item.price
        self.imgName = item.imageName
        self.drinkType = item.drinkType
    }
}
