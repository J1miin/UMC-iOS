import SwiftUI
import PhotosUI

struct ReceiptView: View {
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    @State private var viewModel = ReceiptViewModel()
    @State private var selectedItems: [PhotosPickerItem] = []
    
    @State private var showCamera = false
    @State private var showActionSheet = false
    @State private var showPhotosPicker = false
    
    @State private var showImageModal = false
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        VStack(){
            HStack(){
                Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image("leftArrow")
                }
                Spacer()
                Text("전자영수증")
                Spacer()
                Button(action:{
                    showActionSheet = true
                }){
                    Image("plus")
                }
            }.padding(.horizontal,13.5)
            Spacer()
            if viewModel.receipts.isEmpty {
                Spacer()
                Text("영수증을 추가해주세요")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                // Receipts list
                List {
                    ForEach(viewModel.receipts) { receipt in  // ✅ id 자동 인식
                        receiptCard(for: receipt)  // index → receipt로 변경
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        viewModel.deleteReceipt(receipt)  // ✅ index 대신 receipt 전달
                                    }
                                } label: {
                                    Label("삭제", systemImage: "trash")
                                }
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .padding(.horizontal)
            }
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .confirmationDialog("영수증을 어떻게 추가할까요?", isPresented: $showActionSheet, titleVisibility: .visible) {
            Button("앨범에서 가져오기") {
                showPhotosPicker = true
            }
            Button("카메라로 촬영하기") {
                showCamera = true
            }
            Button("취소", role: .cancel) {}
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker { image in
                viewModel.addImage(image, from:.camera)
            }
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedItems, maxSelectionCount: 5, matching: .images)
        .onChange(of: selectedItems) { oldItems,newItems in
            for item in newItems {
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        viewModel.addImage(image, from: .photoLibrary)
                    }
                }
            }
        }
        
        .fullScreenCover(isPresented: $showImageModal) {
            ZStack {
                Color.black.opacity(0.9).ignoresSafeArea()
                
                Image("dollar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showImageModal = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding(20)
                        }
                    }
                    Spacer()
                }
            }
//            if let image = selectedImage {
//                ZStack {
//                    Color.black.opacity(0.9).ignoresSafeArea()
//
//                    Image("dollar")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 200, height: 200)
//                        .border(Color.red)
//
//                    VStack {
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                showImageModal = false
//                            }) {
//                                Image(systemName: "xmark.circle.fill")
//                                    .font(.system(size: 30))
//                                    .foregroundColor(.white)
//                                    .padding(20)
//                            }
//                        }
//                        Spacer()
//                    }
//                }
//            }
        }
    }
    
    
    private func receiptCard(for receipt: ReceiptModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                if let index = viewModel.receipts.firstIndex(where: { $0.id == receipt.id }){
                    Text("총")
                        .font(.mainTextRegular18)
                    Text("\(index + 1)건")
                        .foregroundColor(.brown01)
                        .font(.mainTextSemiBold18)
                }
        
                Spacer()
                
                Text("사용합계")
                    .font(.mainTextRegular18)
                Text("\(formattedPrice(receipt.totalPrice))")
                    .foregroundColor(.brown01)
                    .font(.mainTextSemiBold18)
            }
            .padding(.bottom, 15)
            
            // Store name
            Text(receipt.store)
                .font(.mainTextSemiBold18)
                .padding(.bottom, 5)
            
            // Date
            HStack {
                Text(formattedDate(receipt.orderDate))
                    .foregroundColor(.gray03)
                    .font(.mainTextMedium16)
                    .padding(.bottom, 5)
                
                Spacer()
                Button(action:{
                    if let image = receipt.image {
                        print("디버깅용 - 이미지 크기: \(image.size)")
                        selectedImage = image
                        showImageModal = true
                    }else{
                        print("사진 없다네")
                    }
                }){
                    Image("dollar")
                }
                .buttonStyle(.plain) // 한 행이 다 버튼클릭된 것처럼 보이는 거 삭제하기 위한 용도
            }
                
            // Price
            Text("\(formattedPrice(receipt.totalPrice))원")
                .font(.mainTextSemiBold18)
                .foregroundColor(.brown02)
            
            Spacer()

            Divider()
                .padding(.top, 15)
        }
        .padding(.vertical, 15)
        .contentShape(Rectangle())
        
        
    }
    
    // Format price with comma separator
    private func formattedPrice(_ price: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
    
    // Format date like "2025.01.05 11:30"
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    ReceiptView()
}
