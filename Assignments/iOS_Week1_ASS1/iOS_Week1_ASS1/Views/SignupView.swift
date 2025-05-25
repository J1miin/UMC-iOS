import SwiftUI

struct SignupView: View {
    @StateObject private var signUpViewModel = SignupViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            textField
            createBtn
        }
        .padding(.horizontal, 19)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("알림"),
                message: Text(alertMessage),
                dismissButton: .default(Text("확인")) {
                    if alertMessage == "회원가입이 완료되었습니다" {
                        dismiss()
                    }
                }
            )
        }
    }
    
    private var textField: some View {
        VStack(alignment: .leading) {
            TextField("닉네임", text: $signUpViewModel.nickname)
                .font(.mainTextRegular18)
                .foregroundColor(Color.gray02)
            Divider()
            
            Spacer().frame(height: 49)
            TextField("이메일", text: $signUpViewModel.email)
                .font(.mainTextRegular18)
                .foregroundColor(Color.gray02)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            Divider()
            Spacer().frame(height: 49)
            
            SecureField("비밀번호", text: $signUpViewModel.pwd)
                .font(.mainTextRegular18)
                .foregroundColor(Color.gray02)
            Divider()
            Spacer().frame(height: 380)
        }
    }
    
    private var createBtn: some View {
        VStack {
            Button(action: {
                if signUpViewModel.saveUserData() {
                    alertMessage = "회원가입이 완료되었습니다"
                    showAlert = true
                } else {
                    alertMessage = "모든 필드를 채워주세요"
                    showAlert = true
                }
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
