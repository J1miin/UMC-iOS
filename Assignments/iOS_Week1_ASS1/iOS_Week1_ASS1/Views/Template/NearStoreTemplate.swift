import SwiftUI
import CoreLocation

// 매장 카테고리 표시를 위한 상수 정의
struct StoreCategory {
    static let reserve = "R"
    static let driveThru = "D"
}

// 매장 정보를 표시하는 템플릿 뷰
struct NearStoreTemplate: View {
    let store: Feature
    let distance: Double
    
    var body: some View {
        HStack(spacing: 12) {
            // 매장 이미지 (예시 이미지로 대체)
            Image("starbucksStore")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .clipped()
            
            VStack(alignment: .leading) {
                Text(store.properties.Sotre_nm)
                    .font(.mainTextSemiBold14)
                    .foregroundColor(.black03)
                Spacer().frame(height: 3)
                Text(store.properties.Address)
                    .font(.system(size: 10))
                    .foregroundColor(.gray02)
                    .lineLimit(1)
                
                Spacer().frame(height: 15)
                HStack{

                    if !store.properties.Category.isEmpty {
                        HStack(spacing: 8) {
                            if store.properties.Category.contains(StoreCategory.reserve) {
                                Image("reserveIcon")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                            }
                            if store.properties.Category.contains(StoreCategory.driveThru) {
                                Image("driveIcon")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                            }
                        }
                    }
                    Spacer()
                    // 거리 표시
                    VStack(alignment: .trailing) {
                        Text("\(String(format: "%.1f", distance))km")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.black01)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}

struct NearStoreTemplate_Previews: PreviewProvider {
    static var previews: some View {
        // 미리보기용 더미 데이터 생성
        let storeProperties = StoreProperties(
            Seq: "1.0",
            Sotre_nm: "서울역",
            Address: "서울 용산구 한강대로 405 (동자동) 신-101호",
            Telephone: "1522-3232",
            Category: "RD", // 리저브와 DT 둘 다 있는 매장
            Ycoordinate: 37.556133,
            Xcoordinate: 126.970738
        )
        
        let geometry = Geometry(type: "Point", coordinates: [126.970738, 37.556133])
        let feature = Feature(type: "Feature", properties: storeProperties, geometry: geometry)
        
        return NearStoreTemplate(store: feature, distance: 2.3)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
