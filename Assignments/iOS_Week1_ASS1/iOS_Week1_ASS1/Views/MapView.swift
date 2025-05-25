import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var storeParsingVM = StoreParsingViewModel()
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var viewModel: MapViewModel
    @State private var lastKnownLocation: CLLocationCoordinate2D?
    @State private var showSearchButton: Bool = false
    @State private var isDragging: Bool = false
    @Namespace var mapScope
    
    init() {
        let storeVM = StoreParsingViewModel()
        let mapVM = MapViewModel(storeParsingVM: storeVM)
        _viewModel = StateObject(wrappedValue: mapVM)
        _storeParsingVM = StateObject(wrappedValue: storeVM)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(initialPosition: viewModel.cameraPosition) {
                // 현재 위치 마커
                if let location = locationManager.location {
                    UserAnnotation()
                }
                
                // 스타벅스 매장 마커
                ForEach(viewModel.markers) { marker in
                    Annotation(marker.title, coordinate: marker.coordinate) {
                        Image(systemName: "mappin.circle.fill")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.red)
                    }
                }
            }
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            .onMapCameraChange { context in
                // 카메라가 움직일 때마다 호출
                isDragging = true
                showSearchButton = true
                
                // 카메라 이동이 끝난 후 0.3초 뒤에 isDragging을 false로 설정
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isDragging = false
                    }
                }
            }
            .onAppear {
                storeParsingVM.loadStore { _ in }
                locationManager.requestLocation()
            }
            .onDisappear {
                viewModel.cleanup()
                locationManager.stopUpdatingLocation()
            }
            
            // 이 지역 검색 버튼
            if showSearchButton && !isDragging {
                VStack {
                    Button(action: {
                        searchNearbyStores()
                    }) {
                        Text("이 지역 검색")
                            .font(.mainTextSemiBold14)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.green01)
                            .cornerRadius(20)
                    }
                    .padding(.bottom, 16)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: showSearchButton)
            }
        }
    }
    
    private func searchNearbyStores() {
        guard let currentLocation = locationManager.location else { return }
        
        // 현재 카메라 위치 기준으로 10km 이내 매장 검색
        viewModel.searchNearbyStores(
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude,
            radius: 10.0
        )
    }
}

#Preview {
    MapView()
}
