//
//  UserInfoInputView.swift
//  USFaceEnroll
//
//  Created by Wee on 23/08/2023.
//

import Foundation
import UIKit
import SwiftUI

class UserInfoInputView: UIView {
    
    enum State {
        case input
        case view
    }
    
    enum InputType: String {
        case username = "Username"
        case phone = "Phone Number"
    }
    
    //MARK: Variable
    //UI
    let textField: UITextField = UITextField()
    
    //Util
    fileprivate var uiState: UserInfoInputView.State = .input
    fileprivate var uiType: UserInfoInputView.InputType = .username
    
    //MARK: Init
    override public init(frame: CGRect) { //for custom view
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aCoder: NSCoder) { //For xib
        super.init(coder: aCoder)
        commonInit()
    }
    
    func setupData(state: UserInfoInputView.State, type: InputType) {
        self.uiState = state
        self.uiType = type
        setupUIByState()
    }
    
    //MARK: Setup Func
    func commonInit() {
        setupLayout()
        setupUI()
    }
    
    fileprivate func setupLayout() {
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
        
    }
    
    fileprivate func setupUI() {
        
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.hcmusColor().cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        
        textField.borderStyle = .none
        textField.textColor = .black
        textField.font = textField.font?.withSize(18)
        
    }
    
    fileprivate func setupUIByState() {
        
        switch uiState {
        case .input:
            textField.attributedPlaceholder = NSAttributedString(string: self.uiType.rawValue,
                                                                 attributes: [
                                                                    .foregroundColor: UIColor.hcmusLightColor()
                                                                 ])
        case .view:
            textField.isEnabled = false
        }
        
    }
    
}

struct SwiftUIFUserInfoInputView: UIViewRepresentable {
    func makeUIView(context: Context) -> UserInfoInputView {
        let v = UserInfoInputView()
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.widthAnchor.constraint(equalToConstant: 180),
            v.heightAnchor.constraint(equalToConstant: 120),
        ])
        return v
        
    }
    func updateUIView(_ view: UserInfoInputView, context: Context) {}
}

struct UserInfoInputView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIFUserInfoInputView()
    }
}
