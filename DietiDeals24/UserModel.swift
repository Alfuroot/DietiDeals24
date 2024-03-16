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
    
    init(user: User){
        username = user.username
        password = user.password
        codicefisc = user.codicefisc
        email = user.email
        address = user.address
    }
}
