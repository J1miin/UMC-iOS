import Foundation
struct MenuItem: Identifiable {
    let id: UUID
    let name: String
    let englishName: String
    let imageName: String
    let category: MenuSegment
    let isNew: Bool
}
