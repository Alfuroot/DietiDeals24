//
//  UserModel.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 13/03/24.
//

import Foundation

class User: Codable {
    var username: String?
    var password: String?
    var codicefisc: String?
    var email: String?
    var address: String?
    
    init(user: User) {
        self.username = user.username
        self.password = user.password
        self.codicefisc = user.codicefisc
        self.email = user.email
        self.address = user.address
    }
    
    init(username: String?, password: String?, codicefisc: String?, email: String?, address: String?) {
        self.username = username
        self.password = password
        self.codicefisc = codicefisc
        self.email = email
        self.address = address
    }
}

