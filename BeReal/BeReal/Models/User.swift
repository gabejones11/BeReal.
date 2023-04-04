//
//  User.swift
//  BeReal
//
//  Created by Gabe Jones on 3/23/23.
//

import Foundation
import ParseSwift

struct User: ParseUser {
    //required properties
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    //custom properties
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String : [String : String]?]?
    var lastPostedDate: Date?
}
