//
//  PersonalAreaView.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 18/03/24.
//

/*
 import SwiftUI
 
 struct PersonalAreaView: View {
     var body: some View {
         NavigationStack{
             Image(systemName: "circle.fill")
                 .resizable()
                 .frame(width: UIScreen.main.bounds.width * 0.4,                        height:UIScreen.main.bounds.height * 0.2)
                 .clipShape(Circle())
             List{
                 Text("Nome utente")
                 Text("Password")
                 Text("Email")
                 Text("Indirizzo")
                 Text("Notifiche")
                 Text("Elimina account")
                 Text("Logout")
                 //NavigationLink(destination: self, label: {Text("")})
             }
         }
     }
 }

 struct PersonalAreaView_Previews: PreviewProvider {
     static var previews: some View {
         PersonalAreaView()
     }
 }

*/

import SwiftUI

struct EditPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var passwordsMatch = true // Initially assuming passwords match

    var body: some View {
        VStack {
            SecureField("Nuova password", text: $newPassword)
                .padding()
            SecureField("Conferma password", text: $confirmPassword)
                .padding()
                .background(passwordsMatch ? Color.clear : Color.red.opacity(0.3))
                .cornerRadius(5)
            if !passwordsMatch {
                Text("Le password non corrispondono")
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
            Button("Salva") {
                // Check if passwords match
                if newPassword == confirmPassword {
                    // Implement password saving logic here
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    passwordsMatch = false
                }
            }
            .padding()
        }
    }
}

struct PersonalAreaView: View {
    @State private var isEditingUsername = false
    @State private var isEditingPassword = false
    @State private var isEditingEmail = false
    @State private var isEditingAddress = false
    @State private var isEditingNotifications = false

    var body: some View {
        NavigationStack {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.4,                        height:UIScreen.main.bounds.height * 0.2)
                .clipShape(Circle())
            List {
                Button(action: { isEditingUsername.toggle() }) {
                    Text("Nome utente")
                }
                .sheet(isPresented: $isEditingUsername) {
                    EditProfileDetailView(title: "Nome utente", currentValue: "Username")
                }

                Button(action: { isEditingPassword.toggle() }) {
                    Text("Password")
                }
                .sheet(isPresented: $isEditingPassword) {
                    EditPasswordView()
                }

                Button(action: { isEditingEmail.toggle() }) {
                    Text("Email")
                }
                .sheet(isPresented: $isEditingEmail) {
                    EditProfileDetailView(title: "Email", currentValue: "email@example.com")
                }

                Button(action: { isEditingAddress.toggle() }) {
                    Text("Indirizzo")
                }
                .sheet(isPresented: $isEditingAddress) {
                    EditProfileDetailView(title: "Indirizzo", currentValue: "Indirizzo attuale")
                }

                Button(action: { isEditingNotifications.toggle() }) {
                    Text("Notifiche")
                }
                .sheet(isPresented: $isEditingNotifications) {
                    EditProfileDetailView(title: "Notifiche", currentValue: "Abilita/Disabilita")
                }

                Text("Elimina account")
                    .foregroundColor(.red)

                Text("Logout")
            }
        }
    }
}


struct EditProfileDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let title: String
    @State private var editedValue: String

    init(title: String, currentValue: String) {
        self.title = title
        self._editedValue = State(initialValue: currentValue)
    }

    var body: some View {
        VStack {
            TextField("Nuovo \(title.lowercased())", text: $editedValue)
                .padding()
            Button("Salva") {
                // Implementa il salvataggio dei dati qui
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}

struct PersonalAreaView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalAreaView()
    }
}

