import Foundation
enum OrderSegment: Int, CaseIterable, Identifiable {
    case wholeMenu
    case myMenu
    case wholeCake
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .wholeMenu:
            return "전체 메뉴"
        case .myMenu:
            return "나만의 메뉴"
        case .wholeCake:
            return "홀케이크 예약"
        }
    }
    
}

enum MenuSegment: Int, CaseIterable, Identifiable {
    case drink
    case food
    case goods
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .drink: return "음료"
        case .food: return "푸드"
        case .goods: return "상품"
        }
    }
}

