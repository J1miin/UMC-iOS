//
//  HomeViewModel.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 4/6/25.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var displayNickname: String = ""
    
    init() {
        loadNickname()
        // 로그인 성공 알림 구독
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLoginSuccess),
            name: Notification.Name("KakaoLoginSuccess"),
            object: nil
        )
        
        // 로그아웃 성공 알림 구독
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLogoutSuccess),
            name: Notification.Name("LogoutSuccess"),
            object: nil
        )
    }
    
    func loadNickname() {
        if let userInfo = KeychainService.shared.loadUser() {
            DispatchQueue.main.async {
                self.displayNickname = userInfo.nickname
            }
        } else {
            DispatchQueue.main.async {
                self.displayNickname = "(설정한 닉네임)"
            }
        }
    }
    
    @objc private func handleLoginSuccess() {
        loadNickname()
    }
    
    @objc private func handleLogoutSuccess() {
        DispatchQueue.main.async {
            self.displayNickname = "(설정한 닉네임)"
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @Published var coffeeItems: [CoffeeItem] = [
        CoffeeItem(id: UUID(), name: "에스프레소 콘파나", eName: "Espresso Con Panna", price: 4100, imageName: "espresso_conpanna", description: "에스프레소에 휘핑크림을 얹은 음료", drinkType: [.hot]),
        CoffeeItem(id: UUID(), name: "에스프레소 마키아또", eName: "Espresso Macchiato", price: 3900, imageName: "espresso_macchiato", description: "에스프레소에 우유 거품을 얹은 음료", drinkType: [.iced]),
        CoffeeItem(id: UUID(), name: "아이스 카페 아메리카노", eName: "Iced Cafe Americano", price: 4500, imageName: "ice_americano", description: "에스프레소에 물을 더한 시원한 음료", drinkType: [.hot, .iced]),
        CoffeeItem(id: UUID(), name: "카페 아메리카노", eName: "Cafe Americano", price: 4500, imageName: "cafe_americano", description: "에스프레소에 물을 더한 음료", drinkType: [.hot, .iced]),
        CoffeeItem(id: UUID(), name: "아이스 카라멜 마키아또", eName: "Iced Caramel Macchiato", price: 5900, imageName: "ice_caramel_macchiato", description: "에스프레소, 스팀 밀크, 우유 거품이 어우러진 시원한 음료", drinkType: [.hot, .iced]),
        CoffeeItem(id: UUID(), name: "카라멜 마키아또", eName: "Caramel Macchiato", price: 5900, imageName: "caramel_macchiato", description: "에스프레소, 스팀 밀크, 우유 거품이 어우러진 음료", drinkType: [.hot, .iced])
    ]

    
    @Published var newsItems: [NewsItem] = [
        NewsItem(
            id: UUID(),
            title: "25년 3월 일회용컵 없는 날 캠페인",
            description: "매월 10일은 일회용컵 없는 날! 스타벅스 매장에서 개인컵 및 다회용 컵을 이용하세요.",
            imageName: "news1"
        ),
        NewsItem(
            id: UUID(),
            title: "스타벅스 OOO점을 찾습니다",
            description: "스타벅스 커뮤니티 스토어 파트너를 공모합니다.",
            imageName: "news2"
        ),
        NewsItem(
            id: UUID(),
            title: "스타벅스 신규 매장 소식",
            description: "새로운 스타벅스 매장을 만나보세요.",
            imageName: "news3"
        )
    ]
    
    @Published var dessertItems : [DessertItem] = [
        DessertItem(
            id: UUID(),
            name: "너티 크루아상",
            imageName: "naughty"
        ),
        DessertItem(
            id: UUID(),
            name: "매콤 소시지 불고기",
            imageName: "spicy"
        ),
        DessertItem(
            id: UUID(),
            name: "미니 리프 파이",
            imageName: "minipie"
        )
    ]
}

