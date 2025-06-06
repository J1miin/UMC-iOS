import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isFocused: Bool = false
    @State private var isPwdFocused: Bool = false
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var move = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 104)
                mainTitleGroup
                Spacer().frame(height: 104)
                IdPwdGroup
                Spacer().frame(height: 36)
                LoginGroup
            }
            .padding(.horizontal, 19)
            .navigationDestination(isPresented: $move) {
                SignupView()
            }
            .fullScreenCover(isPresented: $loginViewModel.isLoggedIn) {
                MyTabView()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
            // 카카오 로그인 결과 알림 수신 (성공 또는 실패)
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("KakaoLoginSuccess"))) { _ in
                loginViewModel.isLoggedIn = true
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("KakaoLoginFailure"))) { notification in
                if let errorMessage = notification.object as? String {
                    alertMessage = "카카오 로그인 실패: \(errorMessage)"
                } else {
                    alertMessage = "카카오 로그인에 실패했습니다."
                }
                showAlert = true
            }
        }
    }
    
    private var mainTitleGroup: some View {
        VStack(alignment: .leading) {
            Group {
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

    private var IdPwdGroup: some View {
        VStack(alignment: .leading) {
            TextField("아이디", text: $loginViewModel.id, onEditingChanged: { editing in isFocused = editing })
                .font(.mainTextRegular13)
               
            Divider()
                .background(isFocused ? Color.green01 : Color.gray01)
            
            Spacer().frame(height: 47)
            
            SecureField("비밀번호", text: $loginViewModel.pwd)
                .font(.mainTextRegular13)
                .onTapGesture {
                    isPwdFocused = true
                }
                
            Divider()
                .background(isPwdFocused ? Color.green01 : Color.gray01)
            
            Spacer().frame(height: 47)
            
            Button {
                if loginViewModel.id.isEmpty || loginViewModel.pwd.isEmpty {
                    alertMessage = "아이디와 비밀번호를 모두 입력해주세요."
                    showAlert = true
                    return
                }
                
                if !loginViewModel.login() {
                    alertMessage = "아이디 또는 비밀번호가 일치하지 않습니다."
                    showAlert = true
                }
            } label: {
                Image("NormalLogin")
                    .resizable()
                    .frame(width: 364, height: 46)
            }
        }
    }

    private var LoginGroup: some View {
        VStack {
            Button(action: {
                move = true
            }) {
                Text("이메일로 회원가입하기")
                    .underline()
                    .font(.mainTextRegular12)
                    .foregroundStyle(Color.gray04)
            }
            Spacer().frame(height: 19)
            Button(action: {
                loginViewModel.kakaoLogin()
            }) {
                Image("KakaoLogin")
            }

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
                .environmentObject(AuthViewModel())
        }
    }
}
