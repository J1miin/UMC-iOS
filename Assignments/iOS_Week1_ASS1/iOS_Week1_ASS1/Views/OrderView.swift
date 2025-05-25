import SwiftUI

struct OrderView: View {
    @StateObject private var viewModel = OrderViewModel()
    @Namespace private var segmentAnimation
    @State private var showStoreSheet = false
    
    var body: some View {
        VStack(alignment:.leading, spacing: 6) {
            Text("Order")
                .font(.mainTextBold24)
                .foregroundColor(.black03)
                .shadow(color: .black.opacity(0.3), radius: 2, y: 4)
                .padding(.horizontal,23)
                .frame(height:36)
            HStack{
                ForEach(OrderSegment.allCases) { segment in
                    OrderTopSegment(
                        segment: segment,
                        isSelected: viewModel.selectedSegment == segment,
                        namespace: segmentAnimation
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.selectedSegment = segment
                        }
                    }
                }
            }
            .frame(height: 53)
            .background(Color.white) //그림자하려면 배경색 필요
            .shadow(color:.gray04.opacity(0.3), radius: 2, y:3)
    
            OrderTabView(
                selectedSegment: $viewModel.selectedSegment,
                viewModel: viewModel,
                namespace: segmentAnimation
            )
        }
        .frame(maxWidth: .infinity)
        .safeAreaInset(edge: .bottom) {
            Button(action: {
                showStoreSheet = true
            }) {
                VStack(spacing: 0) {
                    HStack {
                        Text("주문할 매장을 선택해 주세요")
                            .foregroundColor(.white)
                            .font(.mainTextSemiBold16)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium))
                    }
                    .padding(.horizontal, 18)
                    .frame(height: 48)
                    .background(.black02)
                    Rectangle()
                        .fill(.gray06) // 원하는 색상/진하기로 조정
                        .frame(height: 1)
                        .offset(y:-10)
                        .padding(.horizontal,19)
                }
            }
        }
        .sheet(isPresented: $showStoreSheet) {
            // onDismiss에서 cleanup() 호출 제거
            StoreSheetView()
                .presentationDragIndicator(.visible)
        }
        .presentationDetents([.medium, .large])
    }
}

struct OrderTopSegment: View {
    let segment: OrderSegment
    let isSelected: Bool
    let namespace: Namespace.ID
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                Text(segment.title)
                    .foregroundColor(isSelected ? .black : .gray04)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                if isSelected {
                    Capsule()
                        .fill(Color.green01)
                        .matchedGeometryEffect(id: "underline", in: namespace)
                        .frame(height: 3)
                        .offset(y: 19)
                        .shadow(color: .green01.opacity(0.4), radius: 4, y: 2)
                } else {
                    Color.clear.frame(height: 3)
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}
    
struct BottomSegment: View {
    let segment: MenuSegment
    let isSelected: Bool
    let namespace: Namespace.ID
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0){
                Text(segment.title)
                    .foregroundColor(isSelected ? .black : .gray04)
                    .font(.mainTextSemiBold16)
                    .frame(maxWidth: .infinity)
                Image("new")
                    .offset(x:-4)
            }.offset(y:5)
        }
        .buttonStyle(.plain)
    }
}


struct OrderTabView: View {
    @Binding var selectedSegment: OrderSegment
    @ObservedObject var viewModel: OrderViewModel
    var namespace: Namespace.ID
    init(
        selectedSegment: Binding<OrderSegment>,
        viewModel: OrderViewModel,
        namespace: Namespace.ID
    ) {
        self._selectedSegment = selectedSegment
        self.viewModel = viewModel
        self.namespace = namespace
    }
    
    var body: some View {
        TabView(selection: $selectedSegment) {
            ForEach(OrderSegment.allCases) { segment in
                OrderTabContent(
                    segment: segment,
                    viewModel: viewModel,
                    namespace: namespace
                )
                .tag(segment)
                //TabView에서 각 뷰를 식별하고,어떤 탭이 선택되었는지 관리할 수 있게 해줌. -> 다른 거 누르면 값 자동 업데이트 함
            }
        }
    }
}

struct OrderTabContent: View {
    let segment: OrderSegment
    @ObservedObject var viewModel: OrderViewModel
    var namespace: Namespace.ID

    var body: some View {
        VStack(alignment: .leading) {
            if segment == .wholeMenu {
                HStack(spacing: 0) {
                    ForEach(MenuSegment.allCases) { menuSegment in
                        BottomSegment(
                            segment: menuSegment,
                            isSelected: viewModel.selectedMenuCategory == menuSegment,
                            namespace: namespace
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.selectedMenuCategory = menuSegment
                            }
                        }
                    }
                }
                .frame(width: 174, height: 45)
                Divider()
                ScrollView {
                    LazyVStack(spacing: 26) {
                        ForEach(viewModel.filteredWholeMenuItems) { item in
                            Order_MenuItemTemplate(item: item)
                        }
                    }.padding(.top,19)
                }
                
            }
        }.padding(.horizontal,23)
    }
}


#Preview {
    OrderView()
}
