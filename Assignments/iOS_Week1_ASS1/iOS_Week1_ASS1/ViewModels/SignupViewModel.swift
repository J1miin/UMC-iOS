//
//  SignupViewModel.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/31/25.
//

import Foundation
import SwiftUI

class SignupViewModel: ObservableObject {
    private var signupModel = SignupModel()
    @Published var nickname : String = ""
    @Published var email : String = ""
    @Published var pwd : String = ""
    @AppStorage("email") private var savedEmail = ""
    @AppStorage("pwd") private var savedPwd = ""
    @AppStorage("nickName") private var savedNickname = ""
    init(){
        let savedData = signupModel.getData()
        self.nickname=savedData.nickName
        self.email=savedData.email
        self.pwd=savedData.password
    }
    
    func saveUserData(){
        if !nickname.isEmpty && !email.isEmpty && !pwd.isEmpty {
            signupModel.setData(nickName: nickname, email: email, password: pwd)
            savedEmail = email
            savedPwd = pwd
            savedNickname = nickname

        } else {
            print("한글자 이상 필요")
        }
    }
}

