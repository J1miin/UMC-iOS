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
            mainTitleGroup
            Spacer().frame(height: 172)
            IdPwdGroup
            Spacer().frame(height: 36)
            LoginGroup
        }
    }
}


private var mainTitleGroup : some View {
    VStack(alignment:.leading){
        Group{
            Image("StarbucksLogo1x").resizable()
                .frame(width: 97, height: 95)
            Text("안녕하세요.\n스타벅스입니다.")
                .font(.mainTextExtraBold24)
            Spacer().frame(height: 19)
            Text("회원 서비스 이용을 위해 로그인 해주세요")
                .font(.mainTextMedium16)
                .foregroundStyle(Color.gray01)
        }
    }
}

private var IdPwdGroup : some View {
    VStack(alignment:.leading){
        Group{
            Text("아이디")
                .font(.mainTextRegular13)
            Divider()
            Spacer().frame(height: 47)
            Text("비밀번호")
                .font(.mainTextRegular13)
            Divider()
            Spacer().frame(height: 47)
            Image("NormalLogin")
        }
    }
}

private var LoginGroup : some View {
    VStack{
        Text("이메일로 로그인하기")
            .underline()
            .font(.mainTextRegular12)
            .foregroundStyle(Color.gray04)
        Spacer().frame(height: 19)
        Image("AppleLogin")
        Spacer().frame(height: 19)
        Image("KakaoLogin")
    }
    
}
#Preview {
    LoginView()
}
