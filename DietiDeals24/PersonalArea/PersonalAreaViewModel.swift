import SwiftUI

class PersonalAreaViewModel: ObservableObject {
    @Published var user: User = User.shared
    @Published var newUsername: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var newEmail: String = ""
    @Published var newAddress: String = ""
    @Published var newBio: String = ""
    @Published var newIban: String = ""
    @Published var newFacebookLink: String = ""
    @Published var newTwitterLink: String = ""
    @Published var newInstagramLink: String = ""
    @Published var newLinkedinLink: String = ""
    @Published var showingEditUsername = false
    @Published var showingEditPassword = false
    @Published var showingEditEmail = false
    @Published var showingEditAddress = false
    @Published var showingEditBio = false
    @Published var showingEditIban = false
    @Published var showingEditSocialLinks = false
    @Published var notificationStatus = false
    
    func loadUserData() {
        Task {
            do {
                let dataLoader = DataLoader()
                let loadedUser = try await dataLoader.loadUserData()
                user = loadedUser
                notificationStatus = User.shared.notificationsEnabled
            } catch {
                print("Failed to load user data: \(error.localizedDescription)")
            }
        }
    }
    
    func updateUsername() {
        user.username = newUsername
    }
    
    func updatePassword() {
        if confirmPassword == newPassword {
            user.setPassword(newPassword)
        } else {
            passwordErrorMessage = "Le due password non corrispondono."
        }
    }
    
    func updateEmail() {
        user.email = newEmail
    }
    
    func updateAddress() {
        user.address = newAddress
    }
    
    func updateBio() {
        user.bio = newBio
    }
    
    func updateIban() {
        user.iban = newIban
    }
    
    func updateSocialLinks() {
        user.facebookLink = newFacebookLink
        user.twitterLink = newTwitterLink
        user.instagramLink = newInstagramLink
        user.linkedinLink = newLinkedinLink
    }
    
    func updateNotification() {
        User.shared.notificationsEnabled = notificationStatus
    }
}
