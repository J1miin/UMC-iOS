import Foundation
import SwiftUI

class OtherViewModel: ObservableObject {
    @Published var savedNickname: String = "" {
        didSet {
            print("✅ savedNickname이 변경됨:", savedNickname)
        }
    }
    
    init() {
        print("✅ OtherViewModel 초기화")
        loadNickname()
        // 로그인 성공 알림 구독
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLoginSuccess),
            name: Notification.Name("KakaoLoginSuccess"),
            object: nil
        )
        
        // 로그아웃 성공 알림 구독 추가
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLogoutSuccess),
            name: Notification.Name("LogoutSuccess"),
            object: nil
        )
    }
    
    func loadNickname() {
        print("✅ loadNickname 호출됨")
        // KeychainService에서 사용자 정보 불러오기
        if let userInfo = KeychainService.shared.loadUser() {
            print("✅ 키체인에서 불러온 닉네임:", userInfo.nickname)
            DispatchQueue.main.async {
                self.savedNickname = userInfo.nickname
                print("✅ savedNickname에 설정된 값:", self.savedNickname)
            }
        } else {
            print("❌ 키체인에서 사용자 정보를 불러올 수 없음")
        }
    }
    
    @objc private func handleLoginSuccess() {
        print("✅ 로그인 성공 알림 받음")
        loadNickname()
    }
    
    @objc private func handleLogoutSuccess() {
        print("✅ 로그아웃 성공 알림 받음")
        DispatchQueue.main.async {
            self.savedNickname = ""
        }
    }
    
    func logout() -> Bool {
        // KeychainService에서 사용자 정보 삭제
        let result = KeychainService.shared.deleteUser()
        // 로그아웃 성공 시 닉네임 초기화
        if result {
            DispatchQueue.main.async {
                self.savedNickname = ""
            }
        }
        return result
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
