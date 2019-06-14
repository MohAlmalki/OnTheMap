//
//  UserInformation.swift
//  OnTheMap
//
//  Created by Mohammed Almalki on 08/06/2019.
//  Copyright © 2019 Mohowsa. All rights reserved.
//

import Foundation

struct UserInformation: Codable{
    let account: UserAccount
    let session: UserSession
}

struct UserAccount: Codable{
    let key: String
    let registered: Bool
}

struct UserSession: Codable{
    let id: String
    let expiration: String
}

struct UserName{
    let firstname: String
    let lastname: String
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
}
