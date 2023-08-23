//
//  UserInfoVC.swift
//  USFaceEnroll
//
//  Created by Wee on 22/08/2023.
//

import Foundation
import UIKit
import SwiftUI

final class UserInfoVC: UIViewController {
    
    enum UIType {
        case Update
        case View
        case Enroll
        case None
    }
    
    fileprivate let faceComparationView: FaceComparationView = FaceComparationView()
    fileprivate let userInfoView: UserInfoView = UserInfoView()
    fileprivate let button: UIButton = UIButton()
    
    fileprivate var faceDetectedImage: UIImage?
    fileprivate var faceDBImage: UIImage?
    
    fileprivate var uiType: UIType = .None
    fileprivate var userInfo: UserInfoModel = UserInfoModel()
    
    convenience init(faceImg: UIImage?, userInfo: UserInfoModel, type: UIType) {
        self.init()
        self.userInfo = userInfo
        self.faceDetectedImage = faceImg
        self.faceDBImage = userInfo.imageDB
        self.uiType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.setupUI()
        self.setupData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
}

extension UserInfoVC {
    
    fileprivate func setupLayout() {
        
        faceComparationView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(faceComparationView)
        self.view.addSubview(userInfoView)
        self.view.addSubview(button)
        
        let safeLayout = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            faceComparationView.topAnchor.constraint(equalTo: safeLayout.topAnchor,constant: 30),
            faceComparationView.centerXAnchor.constraint(equalToSystemSpacingAfter: safeLayout.centerXAnchor, multiplier: 1),
            faceComparationView.widthAnchor.constraint(equalTo: safeLayout.widthAnchor, multiplier: 3/4),
            faceComparationView.heightAnchor.constraint(equalToConstant: 170),
            
            userInfoView.topAnchor.constraint(equalTo: faceComparationView.bottomAnchor, constant: 30),
            userInfoView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: 40),
            userInfoView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -40),
            
            button.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 30),
            button.centerXAnchor.constraint(equalTo: safeLayout.centerXAnchor),
            button.widthAnchor.constraint(equalTo: userInfoView.widthAnchor,multiplier: 1/2),
            button.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
    }
    
    fileprivate func setupUI() {
        
        self.view.backgroundColor = .white
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(18)
        button.backgroundColor = UIColor.hcmusLightColor()
        button.layer.borderColor = UIColor.hcmusColor().cgColor
        button.layer.borderWidth = 3
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        switch uiType {
            
        case .Update:
            button.setTitle("Update", for: .normal)
            faceComparationView.updateUI(type: .Compare)
            userInfoView.setupUI(type: .Input)
            break
        case .View:
            button.setTitle("Face Detect", for: .normal)
            faceComparationView.updateUI(type: .Compare)
            userInfoView.setupUI(type: .View,
                                 name: userInfo.username ?? "#NONAME",
                                 phone: userInfo.phone ?? "#NOPHONE")
            break
        case .Enroll:
            button.setTitle("Enroll", for: .normal)
            userInfoView.setupUI(type: .Input)
            faceComparationView.updateUI(type: .Enroll)
            break
        case .None:
            break
            
        }
        
    }
    
    fileprivate func setupData() {
        self.faceComparationView.setupData(faceDetected: self.faceDetectedImage,
                                           faceDB: self.faceDBImage)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        switch uiType {
            
        case .Update:
            self.updateUser()
            break
            
        case .View:
            let vc = FaceDetectVC()
            self.setRootView(vc: vc)
            break
            
        case .Enroll:
            self.updateUser()
            break
            
        case .None:
            break
            
        }
        
    }
    
    private func updateUser() {
        
        guard let id = userInfo.id else {
            print("ERROR: User ID invalid")
            return
        }
        
        let userName: String = userInfoView.getUsername()
        let phoneNum: String = userInfoView.getPhonenumber()
        
        let req = APIRequest.UpdateUser(id: id, username: userName, phone: phoneNum)
 
        APINetworking.shared.updateUser(req: req, completion: { [weak self] result in
            
            print(result)
            
            DispatchQueue.main.async { [weak self] in
                let vc = FaceDetectVC()
                self?.setRootView(vc: vc)
            }
            
        })
        
    }
    
}

//MARK: UIPreviewer
struct SwiftUIUserInfoVC: UIViewControllerRepresentable {
   
    typealias UIViewControllerType = UserInfoVC
    
    func makeUIViewController(context: Context) -> UserInfoVC {
        return UserInfoVC()
    }
    
    func updateUIViewController(_ view: UserInfoVC, context: Context) {
       
    }
}

struct UserInfoVC_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIUserInfoVC()
    }
}
