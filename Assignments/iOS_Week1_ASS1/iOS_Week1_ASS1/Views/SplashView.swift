//
//  LoginView.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/22/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack{
            Color.green01.edgesIgnoringSafeArea(.all) //위에 상단까지 전부 초록색으로 해준다!
            Image("StarbucksLogo3x") //에셋에 넣은 사진을 불러올 때는 string으로 파일이름 쓰기!
        }
    }
}

#Preview {
    SplashView()
}
