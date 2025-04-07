//
//  LoginView.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/22/25.
//

import SwiftUI

struct LoginView: View {
    @State private var isFocused: Bool = false
    @State private var isPwdFocused: Bool = false
    @StateObject private var loginViewModel = LoginViewModel()
    @AppStorage("email") private var savedEmail = ""
    @AppStorage("pwd") private var savedPwd = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    @State private var move = false
    var body: some View {
        NavigationStack{
            VStack{
                Spacer().frame(height: 104)
                mainTitleGroup
                Spacer().frame(height: 104)
                IdPwdGroup
                Spacer().frame(height: 36)
                LoginGroup
            }
            .padding(.horizontal, 19)
            .navigationDestination(isPresented: $move){
                SignupView()
            }
        }
    }
    
    private var mainTitleGroup : some View {
        VStack(alignment: .leading){
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var IdPwdGroup : some View {
        VStack(alignment:.leading){
            TextField("아이디", text: $loginViewModel.id ,onEditingChanged :{ editing in isFocused = editing})
                .font(.mainTextRegular13)
               
            Divider()
                .background(isFocused ? Color.green01 : Color.gray01)
            
            Spacer().frame(height: 47)
            
            TextField("비밀번호", text: $loginViewModel.pwd , onEditingChanged :{ editing in isPwdFocused = editing})
                .font(.mainTextRegular13)
                
            Divider()
                .background(isPwdFocused ? Color.green01 : Color.gray01)
            Spacer().frame(height: 47)
            Button {
                if loginViewModel.id == savedEmail && loginViewModel.pwd == savedPwd {
                    print("성공")
                    isLoggedIn = true  // 탭뷰로 전환됨
                } else {
                    print("❌ 로그인 실패: 이메일이나 비밀번호가 다릅니다.")
                }
            } label: {
                Image("NormalLogin")
                    .resizable()
                    .frame(width: 364, height: 46)
            }

            
        }
    }

    private var LoginGroup : some View {
        VStack{
            Button(action: {
                move = true
            }) {
                Text("이메일로 회원가입하기")
                    .underline()
                    .font(.mainTextRegular12)
                    .foregroundStyle(Color.gray04)
            }
            Spacer().frame(height: 19)
            Image("KakaoLogin")
            Spacer().frame(height: 19)
            Image("AppleLogin")
        }
        
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
