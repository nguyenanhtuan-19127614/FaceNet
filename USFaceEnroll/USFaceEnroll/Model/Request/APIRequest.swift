//
//  APIRequest.swift
//  USFaceEnroll
//
//  Created by Wee on 22/08/2023.
//

import Foundation

struct APIRequest {
    
    struct FaceAuth: BaseAPIRequest {
        
        let base64: String
        
        enum CodingKeys: String, CodingKey {
            case base64 = "base64"
        }
        
    }
    
    struct UpdateUser: BaseAPIRequest {
        
        let id: String
        let username: String
        let phone: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case username = "username"
            case phone = "phone"
        }
        
    }
    
}
