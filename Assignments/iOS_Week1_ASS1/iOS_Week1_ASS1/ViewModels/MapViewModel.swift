import SwiftUI
import MapKit
import Combine

final class MapViewModel: ObservableObject {
    private let storeParsingVM: StoreParsingViewModel
    
    // 마커 데이터 연동
    @Published private(set) var markers: [MapMarker] = []
    
    @Published var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var currentMapCenter: CLLocationCoordinate2D?
    @Published var didEnterGeofence: Bool = false
    let geofenceCoordinate = CLLocationCoordinate2D(latitude: 37.6199899, longitude: 127.0527963)
    
    // Combine 구독 관리
    private var cancellables = Set<AnyCancellable>()
    private var isActive = true
    
    init(storeParsingVM: StoreParsingViewModel) {
        self.storeParsingVM = storeParsingVM
        setupSubscriptions()
    }
    
    deinit {
        isActive = false
        cancellables.removeAll()
    }
    
    private func setupSubscriptions() {
        // 위치 업데이트 구독
        storeParsingVM.$userLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self, self.isActive else { return }
                self.updateCameraPosition(location)
            }
            .store(in: &cancellables)
        
        // 매장 데이터 업데이트 구독
        storeParsingVM.$nearbyStores
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stores in
                guard let self = self, self.isActive else { return }
                self.updateMarkers(stores: stores)
            }
            .store(in: &cancellables)
    }
    
    // 마커 업데이트 메서드
    private func updateMarkers(stores: [Feature]) {
        guard isActive else { return }
        markers = stores.map { feature in
            MapMarker(
                coordinate: CLLocationCoordinate2D(
                    latitude: feature.geometry.coordinates[1],
                    longitude: feature.geometry.coordinates[0]
                ),
                title: feature.properties.Sotre_nm
            )
        }
    }
    
    // 카메라 위치 업데이트
    private func updateCameraPosition(_ location: CLLocation) {
        guard isActive else { return }
        cameraPosition = .region(MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    // 현재 지도 중심점 기준으로 가까운 매장 검색
    func searchNearbyStores(latitude: Double, longitude: Double, radius: Double) {
        guard isActive else { return }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        storeParsingVM.userLocation = location
        storeParsingVM.calculateNearbyStores()
    }
    
    // 뷰모델 정리
    func cleanup() {
        isActive = false
        cancellables.removeAll()
        markers.removeAll()
    }
}
