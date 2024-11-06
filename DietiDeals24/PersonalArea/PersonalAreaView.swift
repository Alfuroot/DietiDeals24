import SwiftUI

struct PersonalAreaView: View {
    @StateObject private var viewModel = PersonalAreaViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "person.crop.circle")
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
                            Task {
                                await viewModel.updateUsername()
                            }
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
                            Task {
                                await viewModel.updatePassword()
                            }
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
                            Task {
                                await viewModel.updateEmail()
                            }
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
                            Task {
                                await viewModel.updateAddress()
                            }
                        }
                        Button("Annulla", role: .cancel) {}
                    }

                    Button(action: {
                        viewModel.newBio = viewModel.user.bio ?? ""
                        viewModel.showingEditBio.toggle()
                    }) {
                        Text("Bio: \(viewModel.user.bio ?? "Not available")")
                    }
                    .alert("Modifica Bio", isPresented: $viewModel.showingEditBio) {
                        TextField("Nuova bio", text: $viewModel.newBio)
                        Button("Salva") {
                            Task {
                                await viewModel.updateBio()
                            }
                        }
                        Button("Annulla", role: .cancel) {}
                    }

                    Button(action: {
                        viewModel.newIban = viewModel.user.iban ?? ""
                        viewModel.showingEditIban.toggle()
                    }) {
                        Text("IBAN: \(viewModel.user.iban ?? "Not available")")
                    }
                    .alert("Modifica IBAN", isPresented: $viewModel.showingEditIban) {
                        TextField("Nuovo IBAN", text: $viewModel.newIban)
                        Button("Salva") {
                            Task {
                                await viewModel.updateIban()
                            }
                        }
                        Button("Annulla", role: .cancel) {}
                    }

                    Button(action: {
                        viewModel.newFacebookLink = viewModel.user.facebookLink ?? ""
                        viewModel.newTwitterLink = viewModel.user.twitterLink ?? ""
                        viewModel.newInstagramLink = viewModel.user.instagramLink ?? ""
                        viewModel.newLinkedinLink = viewModel.user.linkedinLink ?? ""
                        viewModel.showingEditSocialLinks.toggle()
                    }) {
                        Text("Modifica Social Links")
                    }
                    .alert("Modifica Social Links", isPresented: $viewModel.showingEditSocialLinks) {
                        TextField("Facebook Link", text: $viewModel.newFacebookLink)
                        TextField("Twitter Link", text: $viewModel.newTwitterLink)
                        TextField("Instagram Link", text: $viewModel.newInstagramLink)
                        TextField("LinkedIn Link", text: $viewModel.newLinkedinLink)
                        Button("Salva") {
                            Task {
                                await viewModel.updateSocialLinks()
                            }
                        }
                        Button("Annulla", role: .cancel) {}
                    }

                    Button(action: {
                        if viewModel.user.notificationsEnabled == 1 {
                            viewModel.user.notificationsEnabled = 0
                            viewModel.notificationStatus = 0
                        } else {
                            viewModel.user.notificationsEnabled = 1
                            viewModel.notificationStatus = 1
                        }
                        Task {
                            await viewModel.updateNotification()
                        }
                    }) {
                        Text("Notifiche: \(viewModel.notificationStatus > 0 ? "Abilitate" : "Disabilitate")")
                    }
                }
            }
            .onAppear {
                viewModel.populateFields()
            }
        }
    }
}

struct PersonalAreaView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalAreaView()
    }
}
