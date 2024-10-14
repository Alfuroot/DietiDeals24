import Foundation
import FirebaseAuth
import Combine

class RegisterViewModel: ObservableObject {
    @Published var isVendor: Bool = false
    @Published var isBuyer: Bool = false
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var showRegistrationErrorAlert: Bool = false
    @Published var registrationError: String? = nil
    @Published var isUserRegistered: Bool = false
    
    var isRegistrationDisabled: Bool {
        return username.isEmpty || email.isEmpty || password.isEmpty || passwordConfirm.isEmpty
    }

    var isRegistrationValid: Bool {
        return !username.isEmpty && !email.isEmpty && !password.isEmpty && passwordConfirm == password
    }

    func toggleBuyer() {
        isVendor = false
        isBuyer.toggle()
    }

    func toggleVendor() {
        isBuyer = false
        isVendor.toggle()
    }

    func registerUser() {
        guard isRegistrationValid else {
            showRegistrationErrorAlert = true
            registrationError = "Please fill all fields correctly."
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.registrationError = error.localizedDescription
                self?.showRegistrationErrorAlert = true
                return
            }
            
            self?.isUserRegistered = true
            print("User registered: \(String(describing: result?.user.email))")
            self?.saveUserDetails()
        }
    }

    private func saveUserDetails() {
        
        print("Saving user details for \(username) with email \(email)")
    }
}
