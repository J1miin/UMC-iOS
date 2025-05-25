import SwiftUI

struct RootView: View {
    // 로그인 상태를 관찰할 StateObject 추가
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                MyTabView()
                    // MyTabView 내에서 로그아웃하면 authViewModel을 통해 상태 업데이트
                    .environmentObject(authViewModel)
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
            } else {
                LoginView()
                    // LoginView에서 로그인 성공하면 authViewModel을 통해 상태 업데이트
                    .environmentObject(authViewModel)
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authViewModel.isLoggedIn)
        .onAppear {
            // 앱 시작 시 자동 로그인 체크
            if KeychainService.shared.isUserLoggedIn() {
                authViewModel.isLoggedIn = true
                if let userInfo = KeychainService.shared.loadUser() {
                    authViewModel.nickname = userInfo.nickname
                }
            }
        }
    }
}

// 인증 상태를 관리하는 ViewModel
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false {
        didSet {
            print("isLoggedIn 변경됨:", isLoggedIn)
        }
    }
    @Published var nickname: String = ""
    private let loginViewModel = LoginViewModel()
    
    init() {
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        let status = KeychainService.shared.isUserLoggedIn()
        print("키체인 상태 확인:", status)
        DispatchQueue.main.async {
            self.isLoggedIn = status
            if self.isLoggedIn, let userInfo = KeychainService.shared.loadUser() {
                self.nickname = userInfo.nickname
            }
        }
    }
    
    func login(email: String, password: String) -> Bool {
        loginViewModel.id = email
        loginViewModel.pwd = password
        
        if loginViewModel.login() {
            DispatchQueue.main.async {
                self.isLoggedIn = true
                self.nickname = self.loginViewModel.getUserNickname()
            }
            return true
        }
        return false
    }
    
    func kakaoLogin() {
        loginViewModel.kakaoLogin()
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("KakaoLoginSuccess"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.isLoggedIn = true
            self?.checkLoginStatus()
        }
    }
    
    func logout() {
        print("로그아웃 시작")
        // 키체인에서 사용자 정보 삭제
        _ = KeychainService.shared.deleteUser()
        _ = KeychainService.shared.deleteKakaoToken()
        
        // 상태 업데이트
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.3)) {
                print("로그아웃 상태 업데이트")
                self.isLoggedIn = false
                self.nickname = ""
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

#Preview{
    RootView()
}
