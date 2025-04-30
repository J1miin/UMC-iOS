//
//  CoffeeDetailView.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 4/6/25.
//


import SwiftUI


struct CoffeeDetailView: View {
    @ObservedObject var viewModel: CoffeeDetailViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedType: DrinkTemp = .iced
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.green04)
                    .frame(height: 315)
                    .ignoresSafeArea(edges: .top)
                
                Image(viewModel.selectedCoffee?.imgName ?? "defaultImage")
                    .resizable()
                    .frame(height: 315)
                    .clipped()
                    .ignoresSafeArea(edges: .top)

                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image("back")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                        Spacer()
                        Image("share")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    .padding(.horizontal, 8)
                }
            }

            VStack(alignment: .leading) {
                if let coffee = viewModel.selectedCoffee {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(coffee.kName)
                                .font(.mainTextSemiBold24)
                            Spacer().frame(width: 4)
                            Image("new")
                                .resizable()
                                .frame(width: 20, height: 10)
                            Spacer()
                        }
                        Text(coffee.eName)
                            .font(.mainTextSemiBold14)
                            .foregroundColor(Color.gray01)
                    }

                    Spacer().frame(height: 32)

                    VStack(alignment: .leading, spacing: 20) {
                        Text(coffee.description)
                            .font(.mainTextSemiBold14)
                            .foregroundColor(Color.gray06)
                        Text("\(coffee.price)원")
                            .font(.mainTextBold24)
                    }

                    Spacer().frame(height: 32)

                    // HOT / ICED 버튼
                    if coffee.drinkType.count == 1 {
                        // HOT ONLY or ICE ONLY
                        Button(action: {
                            }) {
                                Text(coffee.drinkType.first?.displayText ?? "")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(coffee.drinkType.contains(.hot) ? .red : .blue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                                    .padding(.horizontal, 30)
                                    .padding(.top, 20)
                            }
                        
                    } else {
                        // HOT / ICED 선택하는 Segmented 버튼 스타일
                        HStack(spacing: 0) {
                            ForEach(coffee.drinkType, id: \.self) { type in
                                Button(action: {
                                    withAnimation {
                                        selectedType = type
                                    }
                                }) {
                                    Text(type.rawValue)
                                        .font(.system(size: 14, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 36)
                                        .foregroundColor(
                                            selectedType == type
                                                ? (type == .hot ? .red : .blue)
                                                : .gray
                                        )
                                        .background(
                                            ZStack {
                                                if selectedType == type {
                                                    Color.white
                                                        .cornerRadius(18)
                                                        .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                                                } else {
                                                    Color.clear
                                                }
                                            }
                                        )
                                }
                            }
                        }
                        .frame(height: 36)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(18)
                        .padding(.horizontal, 30)
                        .padding(.top, 20)

                    }


                    Spacer()
                } else {
                    Text("커피 정보를 불러올 수 없습니다.")
                    Spacer()
                }
            }
            .padding(.horizontal, 10)

            // 주문 버튼
            VStack {
                Button(action: { print("주문하기") }) {
                    Image("orderBar")
                        .resizable()
                        .frame(width: 410, height: 73)
                }
            }
        }
    }
}

#Preview {
    CoffeeDetailView(viewModel: {
        let viewModel = CoffeeDetailViewModel()
        viewModel.setSelectedCoffee(CoffeeDetail(
            kName: "에스프레소 마키아또",
            eName: "Espresso Macchiato",
            description: "강렬한 에스프레소 위에 우유 거품을 얹은 음료",
            price: 3500,
            imgName: "espresso_macchiato",
            drinkType: [.iced] // ICE ONLY 테스트
        ))
        return viewModel
    }())
}


//
//#Preview {
//    CoffeeDetailView(viewModel: {
//        let viewModel = CoffeeDetailViewModel()
//        viewModel.setSelectedCoffee(CoffeeDetail(
//            kName: "아이스 아메리카노",
//            eName: "Iced Americano",
//            description: "에스프레소에 물을 더한 시원한 음료",
//            price: 4500,
//            imgName: "ice_americano",
//            drinkType: [.iced]  // Changed from "ice" string to [.iced] array
//        ))
//        return viewModel
//    }())
//}

struct CoffeeDetailView_Preview: PreviewProvider {
    static var devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            CoffeeDetailView(viewModel: {
                let viewModel = CoffeeDetailViewModel()
                viewModel.setSelectedCoffee(CoffeeDetail(
                    kName: "아이스 아메리카노",
                    eName: "Iced Americano",
                    description: "에스프레소에 물을 더한 시원한 음료",
                    price: 4500,
                    imgName: "ice_americano",
                    drinkType: [.iced]
                ))
                return viewModel
            }())
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }
    }
}
