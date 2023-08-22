//
//  APIResponse.swift
//  USFaceEnroll
//
//  Created by Wee on 22/08/2023.
//

import Foundation

struct APIResponse {
    
    struct FaceAuth: BaseAPIResponse {
        
        let code: Int
        let faceExist: Bool
        let bestID: String
        
        enum CodingKeys: String, CodingKey {
            case code = "code"
            case faceExist = "faceExist"
            case bestID = "bestID"
        }
        
    }
    
}
