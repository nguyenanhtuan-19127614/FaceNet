//
//  UIViewController+Extensions.swift
//  USFaceEnroll
//
//  Created by Wee on 23/08/2023.
//

import UIKit

public extension UIViewController {
    
    func push(vc: UIViewController,
              transType: CATransitionType = CATransitionType.fade,
              transDur: CFTimeInterval = 0.5,
              completion: (() -> Void)? = nil) {
        
        let transition = CATransition()
        transition.duration = transDur
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = transType
        transition.subtype = CATransitionSubtype.fromTop
        
        var navController: UINavigationController?
        if self is UINavigationController {
            navController = self as? UINavigationController
        } else {
            navController = self.navigationController
        }
        
        if let completion = completion {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            if self.responds(to: #selector(getter: navController?.interactivePopGestureRecognizer)) {
                navController?.interactivePopGestureRecognizer?.isEnabled = false
            }
            navController?.view.layer.add(transition, forKey: nil)
            navController?.pushViewController(vc, animated: false)
            CATransaction.commit()
        } else {
            navController?.view.layer.add(transition, forKey: nil)
            navController?.pushViewController(vc, animated: false)
        }
        
    }
    
    func pop(transType: CATransitionType = CATransitionType.fade,
             transDur: CFTimeInterval = 0.5,
             completion: (() -> Void)? = nil) {
        
        let transition:CATransition = CATransition()
        transition.duration = transDur
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = transType
        transition.subtype = CATransitionSubtype.fromRight
        
        var navController: UINavigationController?
        if self is UINavigationController {
            navController = self as? UINavigationController
        } else {
            navController = self.navigationController
        }
        
        if let completion = completion {
            
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            if self.responds(to: #selector(getter: navController?.interactivePopGestureRecognizer)) {
                navController?.interactivePopGestureRecognizer?.isEnabled = false
            }
            navController?.view.layer.add(transition, forKey: kCATransition)
            navController?.popViewController(animated: false)
            CATransaction.commit()
            
        } else {
            
            navController?.view.layer.add(transition, forKey: kCATransition)
            navController?.popViewController(animated: false)
        }
    }
    
    func setRootView(vc: UIViewController,
              transType: CATransitionType = CATransitionType.fade,
              transDur: CFTimeInterval = 0.5,
              completion: (() -> Void)? = nil) {
        
        let transition = CATransition()
        transition.duration = transDur
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = transType
        transition.subtype = CATransitionSubtype.fromTop
        
        var navController: UINavigationController?
        if self is UINavigationController {
            navController = self as? UINavigationController
        } else {
            navController = self.navigationController
        }
        
        if let completion = completion {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            if self.responds(to: #selector(getter: navController?.interactivePopGestureRecognizer)) {
                navController?.interactivePopGestureRecognizer?.isEnabled = false
            }
            navController?.view.layer.add(transition, forKey: nil)
            navController?.setViewControllers([vc], animated: false)
            CATransaction.commit()
        } else {
            navController?.view.layer.add(transition, forKey: nil)
            navController?.setViewControllers([vc], animated: false)
        }
        
    }
    
}
