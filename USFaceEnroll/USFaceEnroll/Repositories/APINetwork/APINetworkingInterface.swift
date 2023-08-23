//
//  APINetworkingInterface.swift
//  USFaceEnroll
//
//  Created by Wee on 22/08/2023.
//

import Foundation

typealias ResponseResult<T:BaseAPIResponse> = ((Result<T, APINetworking.AError>) -> Void)

protocol APINetworkingInterface {
    
    func faceAuth(req: APIRequest.FaceAuth, completion: @escaping ResponseResult<APIResponse.FaceAuth>)
    func updateUser(req: APIRequest.UpdateUser, completion: @escaping ResponseResult<APIResponse.UpdateUser>)
    
}
