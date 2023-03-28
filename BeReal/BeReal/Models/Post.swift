//
//  Post.swift
//  BeReal
//
//  Created by Gabe Jones on 3/26/23.
//

import Foundation
import ParseSwift

struct Post: ParseObject {
    //required properties
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    //custom properties
    var caption: String?
    var user: User?
    var imageFile: ParseFile?

}
