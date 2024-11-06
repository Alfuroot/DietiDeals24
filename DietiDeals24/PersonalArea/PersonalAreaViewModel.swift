import SwiftUI

@MainActor
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
    @Published var notificationStatus = 0

    private let dataLoader = DataLoader()

    func populateFields() {
        newUsername = user.username
        newEmail = user.email
        newAddress = user.address
        newBio = user.bio ?? ""
        newIban = user.iban ?? ""
        newFacebookLink = user.facebookLink ?? ""
        newTwitterLink = user.twitterLink ?? ""
        newInstagramLink = user.instagramLink ?? ""
        newLinkedinLink = user.linkedinLink ?? ""
    }

    func updateUsername() async {
        user.username = newUsername
        let updatedFields: [String: Any] = ["username": newUsername]
        do {
            try await dataLoader.updateUserData(userId: user.id, updatedFields: updatedFields)
        } catch {
            print("Failed to update username: \(error.localizedDescription)")
        }
    }
    
    func updatePassword() async {
        if confirmPassword == newPassword {
            user.setPassword(newPassword)
            let updatedFields: [String: Any] = ["password": newPassword]
            do {
                try await dataLoader.updateUserData(userId: user.id, updatedFields: updatedFields)
            } catch {
                print("Failed to update password: \(error.localizedDescription)")
            }
        } else {
            passwordErrorMessage = "Le due password non corrispondono."
        }
    }
    
    func updateEmail() async {
        user.email = newEmail
        let updatedFields: [String: Any] = ["email": newEmail]
        do {
            try await dataLoader.updateUserData(userId: user.id, updatedFields: updatedFields)
        } catch {
            print("Failed to update email: \(error.localizedDescription)")
        }
    }
    
    func updateAddress() async {
        user.address = newAddress
        let updatedFields: [String: Any] = ["address": newAddress]
        do {
            try await dataLoader.updateUserData(userId: user.id, updatedFields: updatedFields)
        } catch {
            print("Failed to update address: \(error.localizedDescription)")
        }
    }
    
    func updateBio() async {
        user.bio = newBio
        let updatedFields: [String: Any] = ["bio": newBio]
        do {
            try await dataLoader.updateUserData(userId: user.id, updatedFields: updatedFields)
        } catch {
            print("Failed to update bio: \(error.localizedDescription)")
        }
    }
    
    func updateIban() async {
        user.iban = newIban
        let updatedFields: [String: Any] = ["iban": newIban]
        do {
            try await dataLoader.updateUserData(userId: user.id, updatedFields: updatedFields)
        } catch {
            print("Failed to update IBAN: \(error.localizedDescription)")
        }
    }
    
    func updateSocialLinks() async {
        user.facebookLink = newFacebookLink
        user.twitterLink = newTwitterLink
        user.instagramLink = newInstagramLink
        user.linkedinLink = newLinkedinLink

        let updatedFields: [String: Any] = [
            "facebookLink": newFacebookLink,
            "twitterLink": newTwitterLink,
            "instagramLink": newInstagramLink,
            "linkedinLink": newLinkedinLink
        ]
        do {
            try await dataLoader.updateUserData(userId: user.id, updatedFields: updatedFields)
        } catch {
            print("Failed to update social links: \(error.localizedDescription)")
        }
    }
    
    func updateNotification() async {
        user.notificationsEnabled = notificationStatus
        let updatedFields: [String: Any] = ["notificationsEnabled": notificationStatus]
        do {
            try await dataLoader.updateUserData(userId: user.id, updatedFields: updatedFields)
        } catch {
            print("Failed to update notification status: \(error.localizedDescription)")
        }
    }
}
