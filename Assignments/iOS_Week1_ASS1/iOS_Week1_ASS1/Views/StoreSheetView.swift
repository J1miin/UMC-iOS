import SwiftUI

struct StoreSheetView: View {
    @State private var showMap = false
    @State private var selectedSegment: StoreSegment = .nearStore
    @StateObject private var viewModel = StoreParsingViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .center) {
            TopView
            Spacer().frame(height: 24)
            SearchView
            Divider()
            if showMap {
                // 지도 내부의 리스트 버튼 제거 - ZStack과 Button 제거
                if let store = viewModel.storeModel {
                    MapView()
                        .frame(maxWidth: .infinity)
                        // onDisappear에서 cleanup() 호출 제거
                } else {
                    Text("매장 정보가 없습니다.")
                }
                
            } else {
                StoreListView
                    .transition(.opacity)
            }
        }
        .padding(.horizontal, 32.5)
        .padding(.top)
        .task {
            await loadStoreData()
        }
        .animation(.easeInOut, value: showMap)
    }

    private func loadStoreData() async {
        await withCheckedContinuation { continuation in
            viewModel.loadStore { _ in
                continuation.resume()
            }
        }
    }

    var TopView: some View {
        HStack {
            Spacer()
            Text("매장 설정")
                .font(.mainTextMedium16)
                .foregroundStyle(.black03)
            Spacer()
            Button(action: {
                Task {
                    await loadStoreData()
                    withAnimation {
                        showMap.toggle()
                    }
                }
            }) {
                Image(showMap ? "listIcon" : "mapIcon")
            }
        }
    }

    var SearchView: some View {
        VStack(spacing: 23) {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 27)
                    .foregroundStyle(.white01)
                HStack {
                    Text("검색")
                        .font(.mainTextSemiBold14)
                        .foregroundStyle(.gray01)
                    Spacer()
                }
                .padding(.horizontal, 7)
            }
            HStack {
                ForEach(StoreSegment.allCases) { segment in
                    segmentButton(segment: segment)
                    if segment == .nearStore {
                        Divider()
                    }
                }
                Spacer()
            }
            .frame(height: 16)
        }
    }

    @ViewBuilder
    func segmentButton(segment: StoreSegment) -> some View {
        Text(segment.title)
            .foregroundStyle(selectedSegment == segment ? .black03 : .gray03)
            .font(.mainTextSemiBold14)
            .onTapGesture {
                selectedSegment = segment
            }
    }

    var StoreListView: some View {
        ScrollView {
            LazyVStack(spacing: 26) {
                ForEach(viewModel.getStoresBySegment(selectedSegment), id: \.properties.Seq) { store in
                    NearStoreTemplate(
                        store: store,
                        distance: viewModel.calculateDistance(to: store)
                    )
                }
            }
            .padding(.top, 19)
        }
    }
}

#Preview {
    StoreSheetView()
}
