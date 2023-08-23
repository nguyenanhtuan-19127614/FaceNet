//
//  UserInfoView.swift
//  USFaceEnroll
//
//  Created by Wee on 23/08/2023.
//

import Foundation
import UIKit

class UserInfoView: UIView {
    
    enum UIType {
        case Input
        case View
    }
    
    //MARK: Variable
    private let stackView: UIStackView = UIStackView()
    
    private let usernameInfoView: UserInfoInputView = UserInfoInputView()
    private let phoneInfoView: UserInfoInputView = UserInfoInputView()
    
    ///utils
    private let infoViewHeight: CGFloat = 80
    
    //MARK: Init
    override public init(frame: CGRect) { //for custom view
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aCoder: NSCoder) { //For xib
        super.init(coder: aCoder)
        commonInit()
    }
    
    //MARK: Setup Func
    fileprivate func commonInit() {
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        usernameInfoView.translatesAutoresizingMaskIntoConstraints = false
        phoneInfoView.translatesAutoresizingMaskIntoConstraints = false
       
        self.addSubview(stackView)
        
        stackView.fixInView(self)
        NSLayoutConstraint.activate([
            usernameInfoView.heightAnchor.constraint(equalToConstant: infoViewHeight),
            phoneInfoView.heightAnchor.constraint(equalToConstant: infoViewHeight),
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(usernameInfoView)
        stackView.addArrangedSubview(phoneInfoView)
    }
    
    func setupUI(type: UIType, name: String = "", phone: String = "") {
        
        switch type {
        case .Input:
            usernameInfoView.setupData(state: .input, type: .username)
            phoneInfoView.setupData(state: .input, type: .phone)
        case .View:
            usernameInfoView.setupData(state: .view, type: .username)
            usernameInfoView.setText(str: name)
            phoneInfoView.setupData(state: .view, type: .phone)
            phoneInfoView.setText(str: phone)
        }
      
    }
    
    public func getUsername() -> String {
        return usernameInfoView.getText()
    }
    
    public func getPhonenumber() -> String {
        return phoneInfoView.getText()
    }
    
}
