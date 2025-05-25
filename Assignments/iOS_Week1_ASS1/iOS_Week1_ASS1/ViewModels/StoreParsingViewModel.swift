import Foundation
import MapKit
import CoreLocation
import Observation

class StoreParsingViewModel: ObservableObject {
    var storeModel: StoreModel?
    @Published var nearbyStores: [Feature] = []
    @Published var frequentStores: [Feature] = []
    @Published var userLocation: CLLocation = CLLocation(latitude: 37.5665, longitude: 126.9780) // 기본값
    
    // LocationManager 인스턴스 사용
    private let locationManager = LocationManager.shared
    private var locationUpdateTimer: Timer?
    private var isActive = true
    
    init() {
        setupLocationUpdates()
    }
    
    deinit {
        cleanup()
    }
    
    private func setupLocationUpdates() {
        // LocationManager에서 위치 변경 감지하기 위한 타이머 설정
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, self.isActive else { return }
            if let currentLocation = self.locationManager.currentLocation {
                // 사용자 위치 업데이트
                self.updateUserLocation(currentLocation)
            }
        }
    }
    
    func cleanup() {
        isActive = false
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
        nearbyStores.removeAll()
        frequentStores.removeAll()
        storeModel = nil
    }
    
    func loadStore(completion: @escaping (Result<StoreModel, Error>) -> Void) {
        guard isActive else {
            completion(.failure(NSError(domain: "뷰모델이 비활성화되었습니다.", code: 400, userInfo: nil)))
            return
        }
        
        guard let url = Bundle.main.url(forResource: "starbucksGeoData", withExtension: "geojson") else {
            print("geojson 파일 없음")
            completion(.failure(NSError(domain: "파일 못찾아요!", code: 404, userInfo: nil)))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(StoreModel.self, from: data)
            self.storeModel = decoded
            //가까운 매장 계산
            self.calculateNearbyStores()
            print("디코딩 성공")
            completion(.success(decoded))
        } catch {
            print("디코딩 실패: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    //사용자 위치 계산
    func updateUserLocation(_ location: CLLocation) {
        guard isActive else { return }
        self.userLocation = location
        self.calculateNearbyStores()
    }
    
    //매장까지 거리 계산
    func calculateDistance(to store: Feature) -> Double {
        let storeLocation = CLLocation(
            latitude: store.geometry.coordinates[1],
            longitude: store.geometry.coordinates[0]
        )
        
        let distanceInMeters = userLocation.distance(from: storeLocation)
        return distanceInMeters / 1000.0 // 미터를 킬로미터로 변환
    }
    
    func calculateNearbyStores() {
        guard isActive, let storeModel = storeModel else { return }
        
        // 모든 매장에 대해 거리 계산 후 10km 이내의 매장만 필터링하고 거리순으로 정렬
        let storesWithDistance = storeModel.features.map { store -> (feature: Feature, distance: Double) in
            let distance = calculateDistance(to: store)
            return (store, distance)
        }
        
        // 10km 이내의 매장만 필터링하고 거리순으로 정렬
        let sortedStores = storesWithDistance
            .filter { $0.distance <= 10.0 }
            .sorted { $0.distance < $1.distance }
            .map { $0.feature }
        
        // 10km 이내의 모든 매장 저장
        self.nearbyStores = sortedStores
    }
    
    func getStoresBySegment(_ segment: StoreSegment) -> [Feature] {
        switch segment {
        case .nearStore:
            return nearbyStores
        case .oftenStore:
            return frequentStores
        }
    }
}

