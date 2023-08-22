//
//  BaseAPIResponse.swift
//  USFaceEnroll
//
//  Created by Wee on 22/08/2023.
//

import Foundation

protocol BaseAPIResponse: Codable {
    var code: Int { get }
}

extension BaseAPIResponse {
    
    func toJsonString() -> String? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            return jsonString
        } catch {
            print(error)
            return nil
        }
    }
    
    func toJson() -> [String: Any]? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return json
        } catch {
            print(error)
            return nil
        }
        
    }
    
    func toJsonForBase64() -> [String: Any]? {
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .withoutEscapingSlashes
        do {
            let jsonData = try jsonEncoder.encode(self)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return json
        } catch {
            print(error)
            return nil
        }
        
    }
    
    func toDict() -> [String: Any]? {
        
        var dict = [String: Any]()
        let otherSelf = Mirror(reflecting: self)
        
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        
        return dict
        
    }
    
}
