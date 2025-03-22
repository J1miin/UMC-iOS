//
//  LoginView.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/22/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack{
            Spacer().frame(height: 104)
            mainTitleGroup
            Spacer().frame(height: 172)
            IdPwdGroup
            Spacer().frame(height: 36)
            LoginGroup
        }
    }
}


private var mainTitleGroup : some View {
    VStack{
        Group{
            Image("StarbucksLogo1x").resizable()
                .frame(width: 97, height: 95)
            Spacer().frame(height: 28)
            Text("안녕하세요.\n스타벅스입니다.")
                .font(.mainTextExtraBold24)
                .fixedSize(horizontal: false, vertical: true)
            Spacer().frame(height: 19)
            Text("회원 서비스 이용을 위해 로그인 해주세요")
                .font(.mainTextMedium16)
                .foregroundStyle(Color.gray01)
        }.padding(.horizontal, 19)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private var IdPwdGroup : some View {
    VStack(alignment:.leading){
        Group{
            Text("아이디")
                .font(.mainTextRegular13)
                .padding(.horizontal, 19)
            Divider().padding(.horizontal, 19)
            Spacer().frame(height: 47)
            Text("비밀번호")
                .font(.mainTextRegular13)
                .padding(.horizontal, 19)
            Divider().padding(.horizontal, 19)
            Spacer().frame(height: 47)
            Image("NormalLogin")
            .resizable()
            .frame(width: 364, height: 46)
            .padding(.horizontal, 19)
            
        }
    }
}

private var LoginGroup : some View {
    VStack{
        Text("이메일로 회원가입하기")
            .underline()
            .font(.mainTextRegular12)
            .foregroundStyle(Color.gray04)
        Spacer().frame(height: 19)
        Image("KakaoLogin")
        Spacer().frame(height: 19)
        Image("AppleLogin")
    }
    
}

struct SwiftUIView_Preview: PreviewProvider {
    static var devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            LoginView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
