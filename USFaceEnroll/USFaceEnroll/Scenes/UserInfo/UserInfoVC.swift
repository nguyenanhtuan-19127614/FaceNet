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
    
    fileprivate let faceComparationView: FaceComparationView = FaceComparationView()
    fileprivate let userInfoView: UserInfoView = UserInfoView()
    
    fileprivate var faceDetectedImage: UIImage?
    fileprivate var faceDBImage: UIImage?
    
    convenience init(faceImg: UIImage) {
        self.init()
        self.faceDetectedImage = faceImg
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
        
        self.view.addSubview(faceComparationView)
        self.view.addSubview(userInfoView)
        
        let safeLayout = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            faceComparationView.topAnchor.constraint(equalTo: safeLayout.topAnchor,constant: 30),
            faceComparationView.centerXAnchor.constraint(equalToSystemSpacingAfter: safeLayout.centerXAnchor, multiplier: 1),
            faceComparationView.widthAnchor.constraint(equalTo: safeLayout.widthAnchor, multiplier: 3/4),
            faceComparationView.heightAnchor.constraint(equalToConstant: 170),
            
            userInfoView.topAnchor.constraint(equalTo: faceComparationView.bottomAnchor, constant: 30),
            userInfoView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: 40),
            userInfoView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -40),
            
        ])
        
    }
    
    fileprivate func setupUI() {
        
        self.view.backgroundColor = .white
        
    }
    
    fileprivate func setupData() {
        self.faceComparationView.setupData(faceDetected: self.faceDetectedImage,
                                           faceDB: self.faceDBImage)
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
