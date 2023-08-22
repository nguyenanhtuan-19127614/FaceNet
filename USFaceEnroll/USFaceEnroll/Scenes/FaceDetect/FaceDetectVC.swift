//
//  FaceDetectVC.swift
//  USFaceEnroll
//
//  Created by Wee on 22/08/2023.
//

import UIKit
import ATFaceDetectCamera
import ATBaseExtensions
import Vision

class FaceDetectVC: UIViewController {

    let cameraView: ATCameraViewInterface = ATCameraView()
    fileprivate var faceDetected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.fixInView(self.view)
        cameraView.setDelegate(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: { [weak self] in
            self?.cameraView.startCamera()
        })
        
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

}

extension FaceDetectVC: ATCameraViewDelegate {
    
    func cameraViewOutput(sender: ATCameraViewInterface, faceImage: UIImage, fullImage: UIImage, boundingBox: CGRect) {
        print("Success: \(boundingBox)")
        
        if faceDetected {
            return
        }
        faceDetected = true
        self.cameraView.stopCamera()
        
        guard let resizedImage = self.imageWithImage(image:faceImage, scaledToSize: CGSize(width: 224, height: 224)) else {
            return
        }
        let imageData = resizedImage.jpegData(compressionQuality: 1)
        let base64Str = imageData?.base64EncodedString() ?? ""
        let req = APIRequest.FaceAuth(base64: base64Str)
        
        let apiDGroup = DispatchGroup()
        var apiResp: APIResponse.FaceAuth? = nil
        
        apiDGroup.enter()
        APINetworking.shared.faceAuth(req: req, completion: { result in

            switch result {

            case .success(let resp):
                apiResp = resp
                print(resp)
            case .failure(let err):
                print(err)
            }
            
            apiDGroup.leave()
        })
        
        //Handle response
        apiDGroup.notify(queue: .main, execute: { [weak self] in
            
            guard let resp = apiResp else {
                return
            }
            let faceExist = resp.faceExist
            
            if faceExist {
                let vc = UserInfoVC(faceImg: faceImage,
                                    dbImg: UIImage(base64: resp.faceBase64 ?? ""))
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        })
        
    }
    
    func cameraViewOutput(sender: ATCameraViewInterface, invalidFace: VNFaceObservation, invalidType: ATCameraView.FaceState) {
        print("SuccessNot: \(invalidType)")
    }
    
}

