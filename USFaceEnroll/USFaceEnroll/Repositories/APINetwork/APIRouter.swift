//
//  APIRouter.swift
//  USFaceEnroll
//
//  Created by Wee on 22/08/2023.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
   
    private var baseURL: String {
        return "http://172.16.16.127:105"
    }
    
    case faceAuth(APIRequest.FaceAuth)
    case updateUser(APIRequest.UpdateUser)
    
    private var path: String {
        switch self {
        case .faceAuth(_):
            return "/faceAuth"
        case .updateUser(_):
            return "/updateUser"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .faceAuth(_):
            return .post
        case .updateUser(_):
            return .post
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .faceAuth(let param):
            return param.toDict()
        case .updateUser(let param):
            return param.toDict()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let urlStr = baseURL + path
        let urlComponent = URLComponents(string: urlStr)
        let url = urlComponent?.url ?? URL(string: "")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.method = self.method
       
        do {
            request = try JSONEncoding.prettyPrinted.encode(request, with: parameters)
            return request
        } catch {
            return request
        }
       
        
    }
    
}
