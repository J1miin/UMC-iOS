//
//  HomeView.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 4/6/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var selectedCoffee: CoffeeDetail? = nil
    @State private var isDetailPresented: Bool = false
    @State private var showAd: Bool = true

    var body: some View {
        if showAd {
            AdView(showAd: $showAd)
        }
        if !showAd {
            NavigationStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        TopBanner
                        Spacer().frame(height: 13)
                        AdBanner
                        Spacer().frame(height: 10)
                        RecommendView
                        Spacer().frame(height: 20)
                        EventBanner
                        Spacer().frame(height: 20)
                        WhatsNews
                        Spacer().frame(height: 20)
                        BottomBanner
                        Spacer().frame(height: 20)
                        Dessert
                        Spacer().frame(height: 20)
                        BottomBanner2
                    }
                }
                .ignoresSafeArea()
                
                .navigationDestination(isPresented: $isDetailPresented) {
                    if let coffee = selectedCoffee {
                        CoffeeDetailView(viewModel: {
                            let vm = CoffeeDetailViewModel()
                            vm.setSelectedCoffee(coffee)
                            return vm
                        }())
                        .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
        
    }

    private var TopBanner : some View {
        ZStack(alignment: .leading){
            Image("top_img")
                .resizable()
                .scaledToFill()
                .frame(height:226)
                .clipped()
            VStack(alignment: .leading, spacing: 29){
                Spacer().frame(height: 100)
                Text("골든 미모사 그린 티와 함께\n행복한 새해의 축배를 들어요!")
                    .font(.mainTextBold24)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 36.53){
                    //별 게이지
                    VStack(alignment: .leading){
                        Text("11★ until next Reward")
                            .font(.mainTextSemiBold16)
                            .foregroundStyle(Color.brown02)
                        ZStack(alignment: .leading){
                            Image("bg_line")
                            Image("line")
                        }
                    }
                    //옆에 숫자
                    VStack{
                        Button(action:{
                            print("나중에 이동")
                        }){
                            Spacer()
                            HStack(spacing:4){
                                Text("내용 보기 ")
                                    .font(.mainTextRegular13)
                                Image("go_line")
                            }.foregroundStyle(Color.gray06)
                        }
                        Spacer().frame(height: 0)
                        HStack{
                            Text("1").font(.mainTextExtraBold38)
                            Text("/").foregroundStyle(Color.gray01)
                            Text("12★").foregroundStyle(Color.brown02)
                                .font(.mainTextSemiBold14)
                        }
                    }
                }
            }.padding(.horizontal,28.16)
        }.frame(height: 259)
    }
    
    private var AdBanner : some View {
        VStack{
            Image("adBanner")
                .resizable()
        }.padding(.horizontal,10)
    }
    
//    private var RecommendView : some View {
//        VStack(alignment: .leading) {
//            HStack(spacing: 0){
//                Text("\(viewModel.displayNickname)")
//                    .font(.mainTextBold24)
//                    .foregroundStyle(Color.brown01)
//                Text("님을 위한 추천 메뉴")
//                    .font(.mainTextBold24)
//                    .foregroundStyle(Color.black03)
//            }
//            
//            ScrollView(.horizontal) {
//                LazyHStack(spacing: 16) { 
//                    ForEach(viewModel.coffeeItems) { item in
//                        CircleImageCard(coffeeItem: item,  dessertItem: nil)
//                    }
//                }
//            }
//
//        }.padding(.horizontal,20)
//    }
    private var RecommendView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0){
                Text("\(viewModel.displayNickname)")
                    .font(.mainTextBold24)
                    .foregroundStyle(Color.brown01)
                Text("님을 위한 추천 메뉴")
                    .font(.mainTextBold24)
                    .foregroundStyle(Color.black03)
            }
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.coffeeItems) { item in
                        Button(action: {
                            let selected = CoffeeDetail(from: item)
                            selectedCoffee = selected
                            isDetailPresented = true
                        }) {
                            CircleImageCard(coffeeItem: item, dessertItem: nil)

                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    
    private var EventBanner : some View {
        VStack(spacing: 20){
            Image("eventBanner")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 10)
            Image("serviceSuscibe")
                .resizable().scaledToFit()
                .padding(.horizontal, 10)
        }
    }
    private var WhatsNews : some View{
        VStack(alignment: .leading) {
            Text("What's New")
                .font(.mainTextBold24)
                .padding(.horizontal)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.newsItems) { item in
                        NewsCard(newsItem: item)
                    }
                }
                .padding()
            }
        }
    }
    private var BottomBanner : some View {
        VStack(spacing: 20){
            Image("mugBanner")
               .resizable()
               .scaledToFit()
               .padding(.horizontal, 10)
           
            Image("onlineBanner")
               .resizable()
               .scaledToFit()
               .padding(.horizontal, 10)
           
            Image("deliveryBanner")
               .resizable()
               .scaledToFit()
               .padding(.horizontal, 10)
        }
    }
    private var Dessert : some View{
        VStack(alignment: .leading) {
            Text("하루가 달콤해지는 디저트")
                .font(.mainTextBold24)
                .padding(.horizontal)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.dessertItems) { item in
                        CircleImageCard(coffeeItem: nil,  dessertItem: item)
                    }
                }
                .padding()
            }
        }
    }
    private var BottomBanner2 : some View {
        VStack(spacing: 20){
            Image("coldBrewBanner")
               .resizable()
               .scaledToFit()
               .padding(.horizontal, 10)
           
            Image("mainDrinkBanner")
               .resizable()
               .scaledToFit()
               .padding(.horizontal, 10)
        }
    }
    
}

struct Home_Preview: PreviewProvider {
    static var devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            HomeView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
