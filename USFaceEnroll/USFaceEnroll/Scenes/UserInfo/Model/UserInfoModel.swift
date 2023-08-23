//
//  UserInfoModel.swift
//  USFaceEnroll
//
//  Created by Wee on 23/08/2023.
//

import UIKit

enum UserState: String {
    case noInfo = "NOINFO"
    case completed = "COMPLETED"
    case err = "ERR"
}

struct UserInfoModel {
    
    let imageDB: UIImage?
    let username: String?
    let phone: String?
    let id: String?
    
    init(imageDB: UIImage?, username: String?, phone: String?, id: String?) {
        self.imageDB = imageDB
        self.username = username
        self.phone = phone
        self.id = id
    }
    
    init() {
        self.imageDB = nil
        self.username = nil
        self.phone = nil
        self.id = nil
    }
    
}
