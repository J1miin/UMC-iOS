import Foundation
import SwiftUI

class SignupViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var email: String = ""
    @Published var pwd: String = ""
    
    func saveUserData() -> Bool {
        if !nickname.isEmpty && !email.isEmpty && !pwd.isEmpty {
            let userInfo = UserInfo(nickname: nickname, email: email, password: pwd)
            return KeychainService.shared.saveUser(userInfo)
        } else {
            print("모든 필드는 한글자 이상 필요합니다")
            return false
        }
    }
}

