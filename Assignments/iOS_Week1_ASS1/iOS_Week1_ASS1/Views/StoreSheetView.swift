import SwiftUI

struct StoreSheetView: View {
    @State private var showMap = false;
    @State private var selectedSegment: StoreSegment = .nearStore
    @StateObject var viewModel : StoreParsingViewModel = .init()
    
    var body: some View {
        VStack(alignment: .center){
            TopView
            Spacer().frame(height: 24)
            SearchView
            Divider()
            StoreListView
        }
        .padding(.horizontal,32.5)
        .padding(.top)
        .task{
            viewModel.loadStore{ _ in}
        }
    }
    
    func loadStoreData() async {
        viewModel.loadStore{_ in}
    }
    var TopView : some View{
        HStack{
            Spacer()
            Text("매장 설정")
                .font(.mainTextMedium16)
                .foregroundStyle(.black03)
            Spacer()
            Button(action: {
                viewModel.loadStore { result in
                    switch result {
                    case .success(_):
                        self.showMap.toggle()
                    case .failure(let error):
                        print("error: \(error)")
                    }
                }
            }, label: {
                Image("mapIcon")
            })
            .sheet(isPresented: $showMap, content: {
                VStack {
                        if let store = viewModel.storeModel {
                            MapView()
                        }
                    }
            })
        }
    }
    
    
    var SearchView : some View {
        VStack(spacing: 23){
            ZStack{
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 27)
                    .foregroundStyle(.white01)
                HStack(){
                    Text("검색")
                        .font(.mainTextSemiBold14)
                        .foregroundStyle(.gray01)
                    Spacer()
                }.padding(.horizontal,7)
            }
            HStack{
                ForEach(StoreSegment.allCases){
                    segment in segmentButton(segment:segment)
                    if segment == .nearStore{
                        Divider()
                    }
                }
                Spacer()
            }.frame(height: 16)
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

    
    var StoreListView : some View {
        ScrollView {
            LazyVStack(spacing: 26) {
                ForEach(viewModel.getStoresBySegment(selectedSegment), id: \.properties.Seq) { store in
                        NearStoreTemplate(
                            store: store,
                            distance: viewModel.calculateDistance(to: store)
                        )
                    }
            }.padding(.top,19)
        }
    }
    
    
}

#Preview {
    StoreSheetView()
}
