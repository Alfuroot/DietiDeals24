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
    @Published var showRegistrationSuccessAlert: Bool = false
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
    
    func registerUser() async {
        guard isRegistrationValid else {
            showRegistrationErrorAlert = true
            registrationError = "Please fill all fields correctly."
            return
        }
        do {
            try await dataLoader.saveUserData(user:
                                                User(username: username, password: password, codicefisc: codicefisc, email: email, address: address, bio: bio, iban: nil, facebookLink: nil, twitterLink: nil, instagramLink: nil, linkedinLink: nil, notificationsEnabled: 0)
            )
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                if let error = error {
                    self?.registrationError = error.localizedDescription
                    self?.showRegistrationErrorAlert = true
                    return
                }
                
                self?.showRegistrationSuccessAlert = true
            }
        } catch {
            self.registrationError = error.localizedDescription
            self.showRegistrationErrorAlert = true
        }
    }
}
