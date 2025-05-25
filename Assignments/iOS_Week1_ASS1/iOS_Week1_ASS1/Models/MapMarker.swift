import Foundation
import MapKit

/// 지도에 표시되는 마커를 나타내는 모델
/// - Identifiable: 고유 식별자를 위한 프로토콜 준수
/// - coordinate: 마커의 위치 좌표
/// - title: 마커의 제목 (매장 이름)
struct MapMarker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
} 