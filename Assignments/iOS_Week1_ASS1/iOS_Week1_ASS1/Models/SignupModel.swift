//
//  SignupModel.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/31/25.
//

import Foundation
import SwiftUI

class SignupModel : ObservableObject{
    @AppStorage("nickName") private var savedNickname = ""
    @AppStorage("email") private var savedEmail = ""
    @AppStorage("pwd") private var savedPwd = ""

    func setData(nickName:String, email:String, password:String){
        savedNickname = nickName
        savedEmail = email
        savedPwd = password
    }
    
    func getData() -> (nickName: String, email: String, password: String) {
        return (savedNickname, savedEmail, savedPwd)
    }
    
}
