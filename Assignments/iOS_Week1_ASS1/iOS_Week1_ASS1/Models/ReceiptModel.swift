import Foundation
import SwiftData
import UIKit

@Model
class ReceiptModel{
    @Attribute(.unique) var id : UUID
    var store: String //어느 지점
    var totalPrice: Int //총 가격
    var orderDate : Date
    var createdAt: Date
    var imageData: Data?
    
    var image: UIImage? {
            guard let imageData else { return nil }
            return UIImage(data: imageData)
        }
    
    init(
        store: String,
        totalPrice: Int,
        orderDate : Date = Date(),
        createdAt: Date = Date(),
        image: UIImage? = nil
        ) {
            self.id = UUID()
            self.store = store
            self.totalPrice = totalPrice
            self.orderDate = orderDate
            self.createdAt = createdAt
            self.imageData = image?.jpegData(compressionQuality: 0.8)
            print("이미지 데이터 크기: \(image?.jpegData(compressionQuality: 0.8)?.count ?? 0)")
        }
}
