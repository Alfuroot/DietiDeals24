import SwiftUI

struct PersonalAreaView: View {
    @State private var user = User.shared
    @State private var showingEditUsername = false
    @State private var showingEditPassword = false
    @State private var showingEditEmail = false
    @State private var showingEditAddress = false
    @State private var showingEditNotifications = false
    @State private var newUsername: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var passwordErrorMessage: String = ""
    @State private var newEmail: String = ""
    @State private var newAddress: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.2)
                    .clipShape(Circle())
                
                List {
                    Button(action: {
                        newUsername = user.username
                        showingEditUsername.toggle()
                    }) {
                        Text("Nome utente: \(user.username)")
                    }
                    .alert("Modifica Nome Utente", isPresented: $showingEditUsername) {
                        TextField("Nuovo nome utente", text: $newUsername)
                        Button("Salva") {
                            user.username = newUsername
                        }
                        Button("Annulla", role: .cancel) {}
                    }

                    Button(action: {
                        showingEditPassword.toggle()
                    }) {
                        Text("Password")
                    }
                    .alert("Modifica Password", isPresented: $showingEditPassword) {
                        TextField("Nuova password", text: $newPassword)
                            .textContentType(.password)
                        TextField("Conferma password", text: $confirmPassword)
                            .textContentType(.password)
                        if !passwordErrorMessage.isEmpty {
                            Text(passwordErrorMessage)
                                .foregroundStyle(Color.red)
                        }
                        Button("Salva", role: .none) {
                            if confirmPassword == newPassword {
                                user.setPassword(newPassword)
                                
                            } else {
                                passwordErrorMessage = "Le due password non corrispondono."
                            }
                        }
                        Button("Annulla", role: .cancel) {}
                    }
                    
                    Button(action: {
                        newEmail = user.email
                        showingEditEmail.toggle()
                    }) {
                        Text("Email: \(user.email)")
                    }
                    .alert("Modifica Email", isPresented: $showingEditEmail) {
                        TextField("Nuova email", text: $newEmail)
                            .keyboardType(.emailAddress)
                        Button("Salva") {
                            user.email = newEmail
                        }
                        Button("Annulla", role: .cancel) {}
                    }
                    
                    Button(action: {
                        newAddress = user.address
                        showingEditAddress.toggle()
                    }) {
                        Text("Indirizzo: \(user.address)")
                    }
                    .alert("Modifica Indirizzo", isPresented: $showingEditAddress) {
                        TextField("Nuovo indirizzo", text: $newAddress)
                        Button("Salva") {
                            user.address = newAddress
                        }
                        Button("Annulla", role: .cancel) {}
                    }
                    
                    Button(action: {
                        user.notificationsEnabled.toggle()
                    }) {
                        Text("Notifiche: \(user.notificationsEnabled ? "Abilitate" : "Disabilitate")")
                    }
                }
            }
            .onAppear {
                loadUserData()
            }
        }
    }
    
    private func loadUserData() {
        Task {
            do {
                let dataLoader = DataLoader()
                let loadedUser = try await dataLoader.loadUserData()
                user = loadedUser
            } catch {
                print("Failed to load user data: \(error.localizedDescription)")
            }
        }
    }
}

struct PersonalAreaView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalAreaView()
    }
}
