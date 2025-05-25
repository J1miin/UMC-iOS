import Foundation

final class OrderViewModel: ObservableObject {
    @Published var selectedSegment: OrderSegment = .wholeMenu
    @Published var selectedMenuCategory: MenuSegment = .drink
    @Published var wholeMenuItems: [MenuItem] = []
    @Published var myMenuItems: [MenuItem] = []
    @Published var wholeCakeItems: [MenuItem] = []
    
    // isActive 플래그 제거 - 시트 닫힘과 상관없이 데이터 유지
    
    var currentItems: [MenuItem] {
        switch selectedSegment {
        case .wholeMenu: return wholeMenuItems
        case .myMenu: return myMenuItems
        case .wholeCake: return wholeCakeItems
        }
    }
    
    func selectSegment(_ segment: OrderSegment) {
        selectedSegment = segment
        loadData(for: segment)
    }
    
    func loadData(for segment: OrderSegment) {
        // 네트워크, 로컬 DB 등에서 데이터를 불러와서 해당 배열에 저장
        // 예시: wholeMenuItems = fetchWholeMenuItems()
    }
    
    var filteredWholeMenuItems: [MenuItem] {
        wholeMenuItems.filter { $0.category == selectedMenuCategory }
    }
    
    // cleanup 함수 제거 - 데이터를 유지하기 위해
    // 필요시 명시적으로 특정 데이터만 초기화하는 함수들로 대체
    func resetWholeMenuItems() {
        wholeMenuItems.removeAll()
    }
    
    func resetMyMenuItems() {
        myMenuItems.removeAll()
    }
    
    func resetWholeCakeItems() {
        wholeCakeItems.removeAll()
    }
    
    // deinit에서 cleanup 호출 제거
    
    init() {
        wholeMenuItems = [
            MenuItem(id: UUID(), name: "추천", englishName: "Recommend", imageName: "recommend", category: .drink, isNew: true),
            MenuItem(id: UUID(), name: "아이스 카페 아메리카노", englishName: "Reserve Espresso", imageName: "ice_americano", category: .drink, isNew: true),
            MenuItem(id: UUID(), name: "카페 아메리카노", englishName: "Reserve Drip", imageName: "americano", category: .drink, isNew: true),
            MenuItem(id: UUID(), name: "카푸치노", englishName: "Dcaf Coffee", imageName: "cappuccino", category: .drink, isNew: false),
            MenuItem(id: UUID(), name: "아이스 카푸치노", englishName: "Espresso", imageName: "ice_cappuccino", category: .drink, isNew: true),
            MenuItem(id: UUID(), name: "카라멜 마키아또", englishName: "Blonde Coffee", imageName: "caramel_macchiato", category: .drink, isNew: true),
            MenuItem(id: UUID(), name: "아이스 카라멜 마키아또", englishName: "Cold Brew", imageName: "ice_caramel_macchiato", category: .drink, isNew: true),
            MenuItem(id: UUID(), name: "아포가토/기타", englishName: "Others", imageName: "affogato", category: .drink, isNew: false),
            MenuItem(id: UUID(), name: "럼 샷 코르타도", englishName: "Brewed Coffee", imageName: "rum_shot_cortado", category: .drink, isNew: true),
            MenuItem(id: UUID(), name: "라벤더 카페 브레베", englishName: "Teavana", imageName: "lavender_cafe_breve", category: .drink, isNew: true),
            MenuItem(id: UUID(), name: "병음료", englishName: "RTD", imageName: "bottle_drink", category: .drink, isNew: false)
        ]
    }
}
