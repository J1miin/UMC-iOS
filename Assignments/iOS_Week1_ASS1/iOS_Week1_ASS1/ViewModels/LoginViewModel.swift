import Foundation
import SwiftUI
import Alamofire
import AuthenticationServices

class LoginViewModel: NSObject, ObservableObject {
    @Published var id: String = ""
    @Published var pwd: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var nickname: String = ""
    @Published var email: String = ""
    
    // 카카오 API 관련 상수
    private let kakaoAuthBaseURL = "https://kauth.kakao.com"
    private let kakaoAPIBaseURL = "https://kapi.kakao.com"
    private let clientID = "0db36e061a047453c134938ab8e89e6e" // 카카오 개발자 콘솔에서 앱 키 입력
    private let redirectURI = "kakao0db36e061a047453c134938ab8e89e6e://oauth" // 카카오 개발자 콘솔에 등록한 리다이렉트 URI
    
    // 웹 인증 세션
    private var authSession: ASWebAuthenticationSession?
    
    override init() {
        super.init()
        // 초기화 시 자동 로그인 체크하지 않음
        self.isLoggedIn = false
        self.nickname = ""
        self.email = ""
    }
    
    func login() -> Bool {
        if let userInfo = KeychainService.shared.loadUser() {
            if id == userInfo.email && pwd == userInfo.password {
                isLoggedIn = true
                nickname = userInfo.nickname
                email = userInfo.email
                return true
            }
        }
        print("❌ 로그인 실패: 이메일이나 비밀번호가 다릅니다.")
        return false
    }
    
    func getUserNickname() -> String {
        if let userInfo = KeychainService.shared.loadUser() {
            return userInfo.nickname
        }
        return ""
    }
    
    func logout() {
        print("로그아웃 시작")
        
        // 카카오 로그아웃 시도
        if let accessToken = KeychainService.shared.loadKakaoToken() {
            kakaoLogout(accessToken: accessToken)
        }
        
        // 키체인에서 사용자 정보와 토큰 삭제
        let userDeleted = KeychainService.shared.deleteUser()
        let tokenDeleted = KeychainService.shared.deleteKakaoToken()
        
        print("사용자 정보 삭제:", userDeleted ? "성공" : "실패")
        print("토큰 삭제:", tokenDeleted ? "성공" : "실패")
        
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.nickname = ""
            self.email = ""
            
            // 로그아웃 성공 알림 전송
            NotificationCenter.default.post(
                name: Notification.Name("LogoutSuccess"),
                object: nil
            )
            
            print("로그아웃 완료 및 알림 전송")
        }
    }
    
    // MARK: - 카카오 REST API 로그인 구현
    
    func kakaoLogin() {
        // 1. 인증 코드 요청을 위해 카카오 인증 서버로 리다이렉트
        let authURLString = "\(kakaoAuthBaseURL)/oauth/authorize?response_type=code&client_id=\(clientID)&redirect_uri=\(redirectURI)"
        
        guard let authURL = URL(string: authURLString) else {
            print("❌ 유효하지 않은 인증 URL")
            notifyLoginFailure(message: "유효하지 않은 인증 URL")
            return
        }
        
        // ASWebAuthenticationSession을 사용하여 웹 인증
        authSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: "kakao\(clientID)",
            completionHandler: { [weak self] callbackURL, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ 인증 세션 오류: \(error)")
                    self.notifyLoginFailure(message: "인증 과정에서 오류가 발생했습니다")
                    return
                }
                
                guard let callbackURL = callbackURL,
                      let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                      let queryItems = components.queryItems,
                      //아래에서 리다리엑션되어 전달된 code를 파싱해서 추출하는 것이다.
                      let code = queryItems.first(where: { $0.name == "code" })?.value else {
                    print("❌ 인증 코드를 가져올 수 없음")
                    self.notifyLoginFailure(message: "인증 코드를 가져올 수 없습니다")
                    return
                }
                
                // 2. 인증 코드로 액세스 토큰 요청
                self.requestKakaoToken(with: code)
            }
        )
        //웹 인증 화면을 어떤 ViewController 위에 띄울지 알려주는 역할
        authSession?.presentationContextProvider = self
        //임시 웹 브라우저 세션을 사용하고 싶다는 뜻으로 true로 설정하면, 쿠키, 로그인 정보 저장 안함 + 매번 새롭게 로그인하도록 강제함.
            //  사파리의 프라이빗 모드처럼 동작한다.
        authSession?.prefersEphemeralWebBrowserSession = true
        
        DispatchQueue.main.async {
            self.authSession?.start()
        }
    }
    
    private func requestKakaoToken(with authCode: String) {
        let tokenURLString = "\(kakaoAuthBaseURL)/oauth/token"
        
        let parameters: [String: Any] = [
            "grant_type": "authorization_code",
            "client_id": clientID,
            "redirect_uri": redirectURI,
            "code": authCode
        ]
        
        AF.request(tokenURLString,
                   method: .post,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/x-www-form-urlencoded;charset=utf-8"])
            .responseDecodable(of: KakaoTokenResponse.self) { [weak self] response in
                switch response.result {
                case .success(let tokenResponse):
                    print("✅ 토큰 요청 성공: \(tokenResponse.accessToken)")
                    
                    // 토큰 저장
                    _ = KeychainService.shared.saveKakaoToken(tokenResponse.accessToken)
                    
                    // 사용자 정보 요청
                    self?.fetchKakaoUserInfo(accessToken: tokenResponse.accessToken)
                    
                case .failure(let error):
                    print("❌ 토큰 요청 실패: \(error)")
                    self?.notifyLoginFailure(message: "토큰 요청에 실패했습니다")
                }
            }
    }
    
    private func fetchKakaoUserInfo(accessToken: String) {
        let userInfoURLString = "\(kakaoAPIBaseURL)/v2/user/me"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/x-www-form-urlencoded;charset=utf-8"
        ]
        
        AF.request(userInfoURLString,
                   method: .get,
                   headers: headers)
            .responseDecodable(of: KakaoUserInfoResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let userInfo):
                    print("✅ 카카오 계정 정보:", userInfo)
                    print("✅ 카카오 프로필:", userInfo.kakaoAccount.profile as Any)
                    
                    let nickname = userInfo.kakaoAccount.profile?.nickname ?? "카카오 사용자"
                    let email = userInfo.kakaoAccount.email ?? "이메일 없음"
                    
                    print("✅ 설정된 닉네임: \(nickname)")
                    print("✅ 설정된 이메일: \(email)")
                    
                    DispatchQueue.main.async {
                        self.nickname = nickname
                        self.email = email
                    }
                    
                    // UserInfo 객체 생성 후 키체인에 저장
                    let userInfoObj = UserInfo(nickname: nickname, email: email, password: "kakao")
                    let saveResult = KeychainService.shared.saveUser(userInfoObj)
                    print("✅ 키체인 저장 결과: \(saveResult)")
                    
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                        // 로그인 성공 알림 전송
                        self.notifyLoginSuccess()
                    }
                    
                case .failure(let error):
                    print("❌ 사용자 정보 요청 실패: \(error)")
                    self.notifyLoginFailure(message: "사용자 정보를 가져오는데 실패했습니다")
                }
            }
    }
    
    private func kakaoLogout(accessToken: String) {
        let logoutURLString = "\(kakaoAPIBaseURL)/v1/user/logout"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(logoutURLString,
                   method: .post,
                   headers: headers)
            .response { response in
                if let error = response.error {
                    print("❌ 로그아웃 요청 실패: \(error)")
                } else {
                    print("✅ 로그아웃 요청 성공")
                }
            }
    }
    
    // MARK: - 알림 전송 메서드
    
    private func notifyLoginSuccess() {
        NotificationCenter.default.post(
            name: Notification.Name("KakaoLoginSuccess"),
            object: nil
        )
    }
    
    private func notifyLoginFailure(message: String) {
        NotificationCenter.default.post(
            name: Notification.Name("KakaoLoginFailure"),
            object: message
        )
    }
}

// MARK: - ASWebAuthenticationSession Presentation
extension LoginViewModel: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No valid window scene available")
        }
        return window
    }
}

// MARK: - 카카오 응답 모델
struct KakaoTokenResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let refreshToken: String
    let expiresIn: Int
    let refreshTokenExpiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case refreshTokenExpiresIn = "refresh_token_expires_in"
    }
}

struct KakaoUserInfoResponse: Decodable {
    let id: Int64
    let connectedAt: String
    let kakaoAccount: KakaoAccount
    
    enum CodingKeys: String, CodingKey {
        case id
        case connectedAt = "connected_at"
        case kakaoAccount = "kakao_account"
    }
}

struct KakaoAccount: Decodable {
    let email: String?
    let isEmailVerified: Bool?
    let isEmailValid: Bool?
    let profile: KakaoProfile?
    
    enum CodingKeys: String, CodingKey {
        case email
        case isEmailValid = "is_email_valid"
        case isEmailVerified = "is_email_verified"
        case profile
    }
}

struct KakaoProfile: Decodable {
    let nickname: String?
    let profileImageUrl: String?
    let thumbnailImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case profileImageUrl = "profile_image_url"
        case thumbnailImageUrl = "thumbnail_image_url"
    }
}

// MARK: - 키체인 서비스 확장
extension KeychainService {
    func saveKakaoToken(_ token: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "kakaoAccessToken",
            kSecValueData as String: token.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func loadKakaoToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "kakaoAccessToken",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data,
           let token = String(data: data, encoding: .utf8) {
            return token
        }
        
        return nil
    }
    
    func deleteKakaoToken() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "kakaoAccessToken"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
