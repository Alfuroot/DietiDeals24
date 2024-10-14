import Foundation

class Validator {
    func isValidIBAN(_ iban: String) -> Bool {
        let trimmedIBAN = iban.replacingOccurrences(of: " ", with: "").uppercased()

        guard trimmedIBAN.count >= 15 && trimmedIBAN.count <= 34 else {
            return false
        }

        let allowedCharacters = CharacterSet.alphanumerics
        return trimmedIBAN.unicodeScalars.allSatisfy { allowedCharacters.contains($0) }
    }
}
