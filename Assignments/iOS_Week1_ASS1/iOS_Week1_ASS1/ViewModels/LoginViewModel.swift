//
//  LoginModel.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/22/25.
//

import Foundation

class UserViewModel : ObservableObject{
    
    @Published var userModel : UserModel
    init (userModel: UserModel){
        self.userModel = userModel
    }
    
}
