import Foundation

class IBANModalViewModel: ObservableObject {
    @Published var iban: String = ""
    @Published var errorMessage: String = ""
    private var dataLoader = DataLoader()
    private var validator: Validator = Validator()
    
    func isIBANValid() -> Bool {
        return validator.isValidIBAN(iban)
    }

    func validateIBAN() {
        if !isIBANValid() {
            errorMessage = "IBAN non valido. Controlla e riprova."
        } else {
            errorMessage = ""
        }
    }

    func confirmIBAN() async {
        do {
            if isIBANValid() {
                let updatedFields: [String: Any] = [
                        "iban": iban
                    ]
                try await dataLoader.updateUserData(userId: User.shared.id, updatedFields: updatedFields)
                User.shared.iban = iban
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
