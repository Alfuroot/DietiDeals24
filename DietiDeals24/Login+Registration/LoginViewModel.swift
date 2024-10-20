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
    
    var isLoginDisabled: Bool {
        return email.isEmpty || password.isEmpty
    }
    
    var isRegistrationValid: Bool {
        return !username.isEmpty && !email.isEmpty && !password.isEmpty && passwordConfirm == password
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.loginError = error.localizedDescription
                print("Login error: \(self?.loginError ?? "Unknown error")")
                return
            }
            
            self?.isUserLoggedIn = true
            print("User signed in: \(String(describing: result?.user.email))")
        }
    }
    
    func registerUser() {
        guard isRegistrationValid else {
            showRegistrationErrorAlert = true
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.loginError = error.localizedDescription
                self?.showRegistrationErrorAlert = true
                return
            }
            
            print("User registered: \(String(describing: result?.user.email))")
        }
    }
}
