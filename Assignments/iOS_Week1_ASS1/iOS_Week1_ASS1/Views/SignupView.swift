//
//  SignupView.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/31/25.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var signUpViewModel = SignupViewModel()
    var body: some View {
        VStack(alignment:.leading){
            textField
            createBtn
        }.padding(.horizontal, 19)
    }
    
    private var textField : some View{
        VStack(alignment: .leading){
            TextField("닉네임", text: $signUpViewModel.nickname )
                .font(.mainTextRegular18)
                .foregroundColor(Color.gray02)
            Divider()
            
            Spacer().frame(height: 49)
            TextField("이메일", text: $signUpViewModel.email )
                .font(.mainTextRegular18)
                .foregroundColor(Color.gray02)
            Divider()
            Spacer().frame(height: 49)
            
            TextField("비밀번호", text: $signUpViewModel.pwd )
                .font(.mainTextRegular18)
                .foregroundColor(Color.gray02)
            Divider()
            Spacer().frame(height: 380) //길이가 원래는 428인디... 안맞음...
        }
    }
    
    private var createBtn : some View {
        VStack(){
            Button(action: {
                signUpViewModel.saveUserData()
            }) {
                Text("생성하기")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: 58)
                    .background(Color.green01)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.makeMeduim18)
            }
        }
    }
}

struct SwiftUIView_Preview2: PreviewProvider {
    static var devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            SignupView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
