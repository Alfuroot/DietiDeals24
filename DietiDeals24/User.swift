import Foundation

class User: Codable {
    static let shared = User()

    var id: String
    var username: String
    var password: String
    var codicefisc: String
    var email: String
    var address: String
    var bio: String?
    var iban: String?
    var facebookLink: String?
    var twitterLink: String?
    var instagramLink: String?
    var linkedinLink: String?
    var notificationsEnabled: Bool

    private init() {
        self.id = UUID().uuidString
        self.username = ""
        self.password = ""
        self.codicefisc = ""
        self.email = ""
        self.address = ""
        self.bio = nil
        self.iban = nil
        self.facebookLink = nil
        self.twitterLink = nil
        self.instagramLink = nil
        self.linkedinLink = nil
        self.notificationsEnabled = false
    }

    func setPassword(_ newPassword: String) {
        self.password = hashPassword(newPassword)
    }

    private func hashPassword(_ password: String) -> String {
        return password
    }

    func updateUserDetails(username: String?, email: String?, address: String?, bio: String?) {
        if let username = username {
            self.username = username
        }
        if let email = email {
            self.email = email
        }
        if let address = address {
            self.address = address
        }
        if let bio = bio {
            self.bio = bio
        }
    }
}
