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
    var cart: [Offer] = []
    var notificationsEnabled: Bool
    
    private init() {
        self.id = ""
        self.username = ""
        self.password = ""
        self.codicefisc = ""
        self.email = ""
        self.address = ""
        self.notificationsEnabled = false // Default to false
    }

    init(id: String, username: String, password: String, codicefisc: String, email: String, address: String, bio: String? = nil, iban: String? = nil, facebookLink: String? = nil, twitterLink: String? = nil, instagramLink: String? = nil, linkedinLink: String? = nil, notificationsEnabled: Bool = false) {
        self.id = id
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
        self.notificationsEnabled = notificationsEnabled // Initialize notificationsEnabled
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        password = try container.decode(String.self, forKey: .password)
        codicefisc = try container.decode(String.self, forKey: .codicefisc)
        email = try container.decode(String.self, forKey: .email)
        address = try container.decode(String.self, forKey: .address)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        iban = try container.decodeIfPresent(String.self, forKey: .iban)
        facebookLink = try container.decodeIfPresent(String.self, forKey: .facebookLink)
        twitterLink = try container.decodeIfPresent(String.self, forKey: .twitterLink)
        instagramLink = try container.decodeIfPresent(String.self, forKey: .instagramLink)
        linkedinLink = try container.decodeIfPresent(String.self, forKey: .linkedinLink)
        notificationsEnabled = try container.decode(Bool.self, forKey: .notificationsEnabled) // Decode notificationsEnabled
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        try container.encode(codicefisc, forKey: .codicefisc)
        try container.encode(email, forKey: .email)
        try container.encode(address, forKey: .address)
        try container.encodeIfPresent(bio, forKey: .bio)
        try container.encodeIfPresent(iban, forKey: .iban)
        try container.encodeIfPresent(facebookLink, forKey: .facebookLink)
        try container.encodeIfPresent(twitterLink, forKey: .twitterLink)
        try container.encodeIfPresent(instagramLink, forKey: .instagramLink)
        try container.encodeIfPresent(linkedinLink, forKey: .linkedinLink)
        try container.encode(notificationsEnabled, forKey: .notificationsEnabled) // Encode notificationsEnabled
    }

    func setPassword(_ newPassword: String) {
        self.password = hashPassword(newPassword)
    }

    private func hashPassword(_ password: String) -> String {
        return password
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case password
        case codicefisc
        case email
        case address
        case bio
        case iban
        case facebookLink
        case twitterLink
        case instagramLink
        case linkedinLink
        case notificationsEnabled
    }
}
