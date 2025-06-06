//
//  MyTabView.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/31/25.
//

import SwiftUI

struct MyTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Text("Home")
                    Image("home")
                }
                .tag(0)
            Text("Pay")
                .tabItem {
                    Text("Pay")
                    Image("pay")
                }
                .tag(1)
            OrderView()
                .tabItem {
                    Text("Order")
                    Image("order")
                }
                .tag(2)
            ShopView()
                .tabItem {
                    Text("Shop")
                    Image("shop")
                }
                .tag(3)
            OtherView()
                .tabItem {
                    Text("Other")
                    Image("other")
                }
                .tag(4)
        }
        .tint(Color.green02)
    }
}

struct SwiftUIView_Preview4: PreviewProvider {
    static var devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            MyTabView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(AuthViewModel())
        }
    }
}
