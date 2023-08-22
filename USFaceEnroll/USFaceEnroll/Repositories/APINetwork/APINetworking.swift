//
//  APINetworking.swift
//  USFaceEnroll
//
//  Created by Wee on 22/08/2023.
//

import Foundation
import Alamofire

final class APINetworking {
    
    enum AError: Error {
        case invalidRequest
        case nilResponseData
        case decodeResponseFailed
    }
   
    private init() {}
    static let shared: APINetworkingInterface = {
        
        let networking = APINetworking()
        return networking
        
    }()
    
    private let session: Session = {
        
        let sessionConfig = URLSessionConfiguration.af.default
        sessionConfig.timeoutIntervalForRequest = 60
        sessionConfig.timeoutIntervalForResource = 60
        sessionConfig.waitsForConnectivity = true
        
        return Session(configuration: sessionConfig)
        
    }()
    
    func request<T:BaseAPIResponse>(router: APIRouter,respType: T.Type, completion: @escaping ResponseResult<T>) {
        
        self.session.request(router).response { result in
            guard let data = result.data else {
                completion(.failure(.nilResponseData))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.decodeResponseFailed))
            }
        }
        
    }
    
    
}

extension APINetworking: APINetworkingInterface {
    
    func faceAuth(req: APIRequest.FaceAuth, completion: @escaping ResponseResult<APIResponse.FaceAuth>) {
        
        self.request(router: .faceAuth(req),
                     respType: APIResponse.FaceAuth.self,
                     completion: { result in
            completion(result)
        })
        
    }
    
}
