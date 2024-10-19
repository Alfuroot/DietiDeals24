import SwiftUI

struct PersonalAreaView: View {
    @StateObject private var viewModel = PersonalAreaViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.2)
                    .clipShape(Circle())
                
                List {
                    Button(action: {
                        viewModel.newUsername = viewModel.user.username
                        viewModel.showingEditUsername.toggle()
                    }) {
                        Text("Nome utente: \(viewModel.user.username)")
                    }
                    .alert("Modifica Nome Utente", isPresented: $viewModel.showingEditUsername) {
                        TextField("Nuovo nome utente", text: $viewModel.newUsername)
                        Button("Salva") {
                            viewModel.updateUsername()
                        }
                        Button("Annulla", role: .cancel) {}
                    }

                    Button(action: {
                        viewModel.showingEditPassword.toggle()
                    }) {
                        Text("Password")
                    }
                    .alert("Modifica Password", isPresented: $viewModel.showingEditPassword) {
                        TextField("Nuova password", text: $viewModel.newPassword)
                            .textContentType(.password)
                        TextField("Conferma password", text: $viewModel.confirmPassword)
                            .textContentType(.password)
                        if !viewModel.passwordErrorMessage.isEmpty {
                            Text(viewModel.passwordErrorMessage)
                                .foregroundStyle(Color.red)
                        }
                        Button("Salva") {
                            viewModel.updatePassword()
                        }
                        Button("Annulla", role: .cancel) {}
                    }
                    
                    Button(action: {
                        viewModel.newEmail = viewModel.user.email
                        viewModel.showingEditEmail.toggle()
                    }) {
                        Text("Email: \(viewModel.user.email)")
                    }
                    .alert("Modifica Email", isPresented: $viewModel.showingEditEmail) {
                        TextField("Nuova email", text: $viewModel.newEmail)
                            .keyboardType(.emailAddress)
                        Button("Salva") {
                            viewModel.updateEmail()
                        }
                        Button("Annulla", role: .cancel) {}
                    }
                    
                    Button(action: {
                        viewModel.newAddress = viewModel.user.address
                        viewModel.showingEditAddress.toggle()
                    }) {
                        Text("Indirizzo: \(viewModel.user.address)")
                    }
                    .alert("Modifica Indirizzo", isPresented: $viewModel.showingEditAddress) {
                        TextField("Nuovo indirizzo", text: $viewModel.newAddress)
                        Button("Salva") {
                            viewModel.updateAddress()
                        }
                        Button("Annulla", role: .cancel) {}
                    }
                    
                    Button(action: {
                        viewModel.user.notificationsEnabled.toggle()
                    }) {
                        Text("Notifiche: \(viewModel.user.notificationsEnabled ? "Abilitate" : "Disabilitate")")
                    }
                }
            }
            .onAppear {
                viewModel.loadUserData()
            }
        }
    }
}

struct PersonalAreaView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalAreaView()
    }
}
