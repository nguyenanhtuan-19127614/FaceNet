//
//  FaceComparationView.swift
//  USFaceEnroll
//
//  Created by Wee on 22/08/2023.
//

import Foundation
import UIKit
import SwiftUI

class FaceComparationView: UIView {
    
    //MARK: Variable
    fileprivate let faceImgDetected: UIImageView = UIImageView()
    lazy fileprivate var faceImgDatabase: UIImageView = UIImageView()
    lazy fileprivate var connectionView: UIView = UIView()
    
    
    //MARK: Init
    override public init(frame: CGRect) { //for custom view
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aCoder: NSCoder) { //For xib
        super.init(coder: aCoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupCircleView()
    }
    
    //MARK: Setup Func
    func commonInit() {
        setupLayout()
        setupUI()
    }
    
    fileprivate func setupLayout() {
        
        faceImgDetected.translatesAutoresizingMaskIntoConstraints = false
        faceImgDatabase.translatesAutoresizingMaskIntoConstraints = false
        connectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(faceImgDetected)
        self.addSubview(faceImgDatabase)
        self.addSubview(connectionView)
        
        faceImgDetected.image = .actions
        faceImgDatabase.image = .add
        connectionView.backgroundColor = .hcmusColor()
        
        faceImgDetected
        .addLeadingConstraint(to: self)
        .addCenterYConstraint(to: self)
        .addHeightConstraint(to: self,padding: -20, multiplier: 1)
       
        faceImgDatabase
        .addTrailingConstraint(to: self)
        .addCenterYConstraint(to: self)
        .addHeightConstraint(to: self,padding: -20, multiplier: 1)
        
        connectionView
        .addCenterYConstraint(to: self)
        
        NSLayoutConstraint.activate([
            faceImgDetected.widthAnchor.constraint(equalTo: faceImgDetected.heightAnchor, multiplier: 1),
            faceImgDatabase.widthAnchor.constraint(equalTo: faceImgDatabase.heightAnchor, multiplier: 1),
            connectionView.heightAnchor.constraint(equalToConstant: 15),
            connectionView.leadingAnchor.constraint(equalTo: faceImgDetected.trailingAnchor,constant: -2),
            connectionView.trailingAnchor.constraint(equalTo: faceImgDatabase.leadingAnchor,constant: 2)
        ])
        
        
    }
    
    fileprivate func setupUI() {
        
        faceImgDatabase.contentMode = .scaleAspectFit
        faceImgDetected.layer.masksToBounds = true
        faceImgDetected.layer.borderWidth = 4
        faceImgDetected.layer.borderColor = UIColor.hcmusColor().cgColor
        
        faceImgDatabase.contentMode = .scaleAspectFit
        faceImgDatabase.layer.masksToBounds = true
        faceImgDatabase.layer.borderWidth = 4
        faceImgDatabase.layer.borderColor = UIColor.hcmusColor().cgColor
        
    }
    
    fileprivate func setupCircleView() {
        faceImgDetected.layer.cornerRadius = faceImgDetected.frame.width/2
        faceImgDatabase.layer.cornerRadius = faceImgDatabase.frame.width/2
    }
    
    public func setupData(faceDetected: UIImage?, faceDB: UIImage?) {
        self.faceImgDetected.image = faceDetected
        self.faceImgDatabase.image = faceDB
    }
    
}

struct SwiftUIFaceComparationView: UIViewRepresentable {
    func makeUIView(context: Context) -> FaceComparationView {
        let v = FaceComparationView()
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.widthAnchor.constraint(equalToConstant: 180),
            v.heightAnchor.constraint(equalToConstant: 120),
        ])
        return v
        
    }
    func updateUIView(_ view: FaceComparationView, context: Context) {}
}

struct FaceComparationView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIFaceComparationView()
    }
}
