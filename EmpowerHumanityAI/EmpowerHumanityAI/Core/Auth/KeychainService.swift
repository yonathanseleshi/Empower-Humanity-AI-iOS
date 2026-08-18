import Foundation
import Security

final class KeychainService {
    static let shared = KeychainService()

    private let service = "ai.empowerhumanity.EmpowerHumanityAI"

    private init() {}

    // MARK: - Store

    @discardableResult
    func store(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // MARK: - Retrieve

    func retrieve(forKey key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ]
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        return string
    }

    // MARK: - Delete

    @discardableResult
    func delete(forKey key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    // MARK: - Session Token Helpers

    enum Keys {
        static let sessionToken = "session_token"
        static let refreshToken = "refresh_token"
        static let userId = "user_id"
    }

    var sessionToken: String? {
        get { retrieve(forKey: Keys.sessionToken) }
        set {
            if let value = newValue {
                store(value, forKey: Keys.sessionToken)
            } else {
                delete(forKey: Keys.sessionToken)
            }
        }
    }

    var refreshToken: String? {
        get { retrieve(forKey: Keys.refreshToken) }
        set {
            if let value = newValue {
                store(value, forKey: Keys.refreshToken)
            } else {
                delete(forKey: Keys.refreshToken)
            }
        }
    }

    func clearSession() {
        delete(forKey: Keys.sessionToken)
        delete(forKey: Keys.refreshToken)
        delete(forKey: Keys.userId)
    }
}
