import Foundation
import FirebaseAuth
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var showRegistrationErrorAlert: Bool = false
    @Published var loginError: String? = nil
    @Published var isUserLoggedIn: Bool = false
    
    private let dataLoader = DataLoader()

    var isLoginDisabled: Bool {
        return email.isEmpty || password.isEmpty
    }
    
    var isRegistrationValid: Bool {
        return !username.isEmpty && !email.isEmpty && !password.isEmpty && passwordConfirm == password
    }
    
    func login() async {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            isUserLoggedIn = true
            User.shared = try await dataLoader.loadUserData(byEmail: email)
        } catch let error {
            loginError = error.localizedDescription
        }
    }
}
