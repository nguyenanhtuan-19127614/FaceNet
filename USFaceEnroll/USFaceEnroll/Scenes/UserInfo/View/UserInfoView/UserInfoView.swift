//
//  UserInfoView.swift
//  USFaceEnroll
//
//  Created by Wee on 23/08/2023.
//

import Foundation
import UIKit

class UserInfoView: UIView {
    
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
    func commonInit() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        
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
    
    func setupUI() {
        usernameInfoView.setupData(state: .input, type: .username)
        phoneInfoView.setupData(state: .input, type: .phone)
    }
    
    
}
