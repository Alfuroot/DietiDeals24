import Foundation

class Validator {
    func isValidIBAN(_ iban: String) -> Bool {
        let trimmedIBAN = iban.replacingOccurrences(of: " ", with: "").uppercased()

        guard trimmedIBAN.count >= 15 && trimmedIBAN.count <= 34 else {
            return false
        }
        
        let allowedCharacters = CharacterSet.alphanumerics
        guard trimmedIBAN.unicodeScalars.allSatisfy({ allowedCharacters.contains($0) }) else {
            return false
        }

        let rearrangedIBAN = rearrangeIBAN(trimmedIBAN)
        
        guard let numericIBAN = convertToNumeric(iban: rearrangedIBAN) else {
            return false
        }

        return mod97(numericIBAN) == 1
    }

    private func rearrangeIBAN(_ iban: String) -> String {
        let firstFour = iban.prefix(4)
        let rest = iban.dropFirst(4)
        return String(rest + firstFour)
    }

    private func convertToNumeric(iban: String) -> String? {
        var numericIBAN = ""
        
        for character in iban {
            if let digit = character.wholeNumberValue {
                numericIBAN.append(String(digit))
            } else if let scalar = character.unicodeScalars.first?.value {
                let numericValue = scalar - UnicodeScalar("A").value + 10
                numericIBAN.append(String(numericValue))
            } else {
                return nil
            }
        }
        
        return numericIBAN
    }

    private func mod97(_ numericIBAN: String) -> Int {
        var remainder = 0
        for character in numericIBAN {
            remainder = (remainder * 10 + character.wholeNumberValue!) % 97
        }
        return remainder
    }
}
