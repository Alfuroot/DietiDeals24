import Foundation
import FirebaseAuth
import Combine

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var isVendor: Bool = false
    @Published var isBuyer: Bool = false
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var address: String = ""
    @Published var bio: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var codicefisc: String = ""
    @Published var showRegistrationErrorAlert: Bool = false
    @Published var registrationError: String? = nil
    @Published var isUserRegistered: Bool = false
    
    private var dataLoader = DataLoader()
    
    var isRegistrationDisabled: Bool {
        return username.isEmpty || email.isEmpty || address.isEmpty || bio.isEmpty || password.isEmpty || passwordConfirm.isEmpty || codicefisc.isEmpty
    }

    var isRegistrationValid: Bool {
        return !username.isEmpty && !email.isEmpty && !address.isEmpty && !bio.isEmpty && !password.isEmpty && passwordConfirm == password && !codicefisc.isEmpty
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
        Task {
            do {
                try await dataLoader.saveUserData(user: User(username: self.username, password: self.password, codicefisc: self.codicefisc, email: self.email, address: self.address, notificationsEnabled: true))
            } catch {
                
            }
        }
    }
}
