import Foundation
enum StoreSegment: Int, CaseIterable, Identifiable {
    case nearStore
    case oftenStore
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .nearStore:
            return "가까운 매장"
        case .oftenStore:
            return "자주가는 매장"
        }
    }
}
