//
//  OtherView.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/31/25.
//

import SwiftUI

struct OtherView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    @StateObject private var otherViewModel = OtherViewModel()
    var body: some View {
        VStack{
            TopBar
            Spacer().frame(height: 41)
            welcomField
            Spacer().frame(height:24)
            welcomeField2
            Spacer().frame(height: 41)
            payField
            Spacer().frame(height: 41)
            ServiceField            
        }
    }
    
    var TopBar: some View {
        HStack{
            Text("Other")
                .font(.mainTextBold24)
            Spacer()
            Button(action: {
                isLoggedIn = false
                print("logout")})
            {
                Image("logout")
            }
        }
        .padding(.horizontal,19.5)
        .background(.white)
    }
    
    var welcomField : some View {
        VStack{
            Text("\(otherViewModel.savedNickname)")
                .font(.mainTextSemiBold24)
                .foregroundStyle(Color.green02)
            + Text("님 \n환영합니다!🙌🏻")
                .font(.mainTextSemiBold24)
        }.multilineTextAlignment(.center) //텍스트 중앙 정렬하기
    }
    
    var welcomeField2 : some View {
        HStack{
            BtnTemplate(title: "별 히스토리", imageName: "star_history")
            Spacer().frame(width: 10.5)
            BtnTemplate(title: "전자 영수증", imageName: "receipt")
            Spacer().frame(width: 10.5)
            BtnTemplate(title: "나만의 메뉴", imageName: "my")
        }
    }
    
    var payField : some View {
        VStack(){
            Text("Pay")
                .font(.mainTextSemiBold18)
                .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬
            
            Spacer().frame(height: 24)
            
            HStack(spacing: 104) {
                ImgBtnTemplate(title: "스타벅스 카드 등록", imgName: "card")
                ImgBtnTemplate(title: "카드 교환권 등록", imgName: "card_change")
            }
            Spacer().frame(height: 16)
            
            HStack(spacing: 104) {
                ImgBtnTemplate(title: "쿠폰 등록", imgName: "coupon")
                ImgBtnTemplate(title: "쿠폰 히스토리", imgName: "coupon_history")
            }
            Spacer().frame(height: 16)
        }.padding(.horizontal,19)
    }
    
    var ServiceField : some View {
        VStack(){
            Text("고객지원")
                .font(.mainTextSemiBold18)
                .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬
            
            Spacer().frame(height: 24)
            
            HStack(spacing: 104) {
                ImgBtnTemplate(title: "스토어 케어", imgName: "store_care")
                ImgBtnTemplate(title: "고객의 소리", imgName: "customer")
            }
            Spacer().frame(height: 16)
            HStack(spacing: 104) {
                ImgBtnTemplate(title: "매장 정보", imgName: "store_info")
                ImgBtnTemplate(title: "반납기 정보", imgName: "return_info")
            }
            Spacer().frame(height: 16)
            HStack(spacing: 104) {
                ImgBtnTemplate(title: "마이 스타벅스 리뷰", imgName: "my_review")
            }
        }.padding(.horizontal,19)
    }
    
}

#Preview {
    OtherView()
}
