//
//  UIImage+Extensions.swift
//  USFaceEnroll
//
//  Created by Wee on 23/08/2023.
//

import Foundation
import UIKit
extension UIImage {
    
    public convenience init?(base64: String) {
        guard let dataDecoded : Data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else  {
            return nil
        }
        self.init(data: dataDecoded)
    }
    
}
