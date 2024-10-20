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
    
    init(username: String, password: String, codicefisc: String, email: String, address: String, bio: String? = nil, iban: String? = nil, facebookLink: String? = nil, twitterLink: String? = nil, instagramLink: String? = nil, linkedinLink: String? = nil, notificationsEnabled: Bool) {
        self.id = UUID().uuidString
        self.username = username
        self.password = password
        self.codicefisc = codicefisc
        self.email = email
        self.address = address
        self.bio = bio
        self.iban = iban
        self.facebookLink = facebookLink
        self.twitterLink = twitterLink
        self.instagramLink = instagramLink
        self.linkedinLink = linkedinLink
        self.notificationsEnabled = notificationsEnabled
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.password = try container.decode(String.self, forKey: .password)
        self.codicefisc = try container.decode(String.self, forKey: .codicefisc)
        self.email = try container.decode(String.self, forKey: .email)
        self.address = try container.decode(String.self, forKey: .address)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
        self.iban = try container.decodeIfPresent(String.self, forKey: .iban)
        self.facebookLink = try container.decodeIfPresent(String.self, forKey: .facebookLink)
        self.twitterLink = try container.decodeIfPresent(String.self, forKey: .twitterLink)
        self.instagramLink = try container.decodeIfPresent(String.self, forKey: .instagramLink)
        self.linkedinLink = try container.decodeIfPresent(String.self, forKey: .linkedinLink)
        self.notificationsEnabled = try container.decode(Bool.self, forKey: .notificationsEnabled)
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
