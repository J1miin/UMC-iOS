import Foundation
import Security

struct UserInfo: Codable {
    let nickname: String
    let email: String
    let password: String
}

class KeychainService {
    static let shared = KeychainService()
    
    private init() {}
    
    private let account = "userInfo"
    private let service = "com.starbucks.userInfo"
    
    @discardableResult
    private func saveUserInfo(_ userInfo: UserInfo) -> OSStatus {
        do {
            let data = try JSONEncoder().encode(userInfo)
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: account,
                kSecAttrService as String: service,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
            ]
            
            SecItemDelete(query as CFDictionary)
            
            return SecItemAdd(query as CFDictionary, nil)
        } catch {
            print("JSON 인코딩 실패:", error)
            return errSecParam
        }
    }
    
    private func loadUserInfo() -> UserInfo? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let data = item as? Data else {
            print("사용자 정보 불러오기 실패 - status:", status)
            return nil
        }
        
        do {
            return try JSONDecoder().decode(UserInfo.self, from: data)
        } catch {
            print("❌ JSON 디코딩 실패:", error)
            return nil
        }
    }
    
    @discardableResult
    private func deleteUserInfo() -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]
        
        return SecItemDelete(query as CFDictionary)
    }
    
    public func saveUser(_ userInfo: UserInfo) -> Bool {
        let saveStatus = self.saveUserInfo(userInfo)
        let success = saveStatus == errSecSuccess
        print(success ? "사용자 정보 저장 성공" : "사용자 정보 저장 실패")
        return success
    }
    
    public func loadUser() -> UserInfo? {
        return self.loadUserInfo()
    }
    
    public func deleteUser() -> Bool {
        let deleteStatus = self.deleteUserInfo()
        let success = (deleteStatus == errSecSuccess) || (deleteStatus == errSecItemNotFound)
        print(success ? "사용자 정보 삭제 성공" : "사용자 정보 삭제 실패 - status: \(deleteStatus)")
        return success
    }
    
    public func isUserLoggedIn() -> Bool {
        return self.loadUserInfo() != nil
    }
}
