//
//  Presenter.swift
//  MVVM-C-Box
//
//  Created by Anton Gutkin on 28.01.2022.
//

import Foundation
import UIKit

enum PresentatitonType {
    case push
    case presentModally(presentationStyle: UIModalPresentationStyle? = nil)
    
    init?(actionType: ActionType) {
        switch actionType {
        case .push:
            self = .push
        case .show(let presentationStyle):
            self = .presentModally(presentationStyle: presentationStyle)
        }
    }
}

protocol Presenter: AnyObject {
    func present(controller: UIViewController, presentationType: PresentatitonType, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, presentationType: PresentatitonType, completion: (() -> Void)?)
}

extension UIViewController: Presenter {
    func present(controller: UIViewController, presentationType: PresentatitonType, animated: Bool, completion: (() -> Void)? = nil) {
        let presentationHandler = { [weak self] in
            if let navigationController = self as? UINavigationController {
                switch presentationType {
                case .push:
                    navigationController.pushViewController(controller, animated: animated)
                    completion?()
                case .presentModally(let presentationStyle):
                    if let modalPresentationStyle = presentationStyle {
                        controller.modalPresentationStyle = modalPresentationStyle
                    }
                    
                    navigationController.topViewController?.present(controller, animated: animated, completion: completion)
                }
            } else {
                switch presentationType {
                case .push:
                    self?.navigationController?.pushViewController(controller, animated: animated)
                    completion?()
                case .presentModally(let presentationStyle):
                    if let modalPresentationStyle = presentationStyle {
                        controller.modalPresentationStyle = modalPresentationStyle
                    }
                    
                    self?.present(controller, animated: animated, completion: completion)
                }
            }
        }
        
        guard let modallyPresentedController = presentedViewController else {
            presentationHandler()
            return
        }
        
        modallyPresentedController.dismiss(animated: true, completion: {
            presentationHandler()
        })
    }
    
    func dismiss(animated: Bool, presentationType: PresentatitonType, completion: (() -> Void)? = nil) {
        if let navigationController = self as? UINavigationController {
            switch presentationType {
            case .push:
                navigationController.popViewController(animated: animated)
                completion?()
            case .presentModally:
                navigationController.topViewController?.dismiss(animated: animated, completion: completion)
            }
        } else {
            switch presentationType {
            case .push:
                navigationController?.popViewController(animated: true)
                completion?()
            case .presentModally:
                dismiss(animated: animated, completion: completion)
            }
        }
    }
}

extension UIWindow: Presenter {
    func present(controller: UIViewController, presentationType: PresentatitonType, animated: Bool, completion: (() -> Void)? = nil) {
        if let rootViewController = rootViewController {
            rootViewController.present(controller: controller, presentationType: presentationType, animated: animated, completion: completion)
        } else {
            rootViewController = controller
            completion?()
        }
    }
    
    func dismiss(animated: Bool, presentationType: PresentatitonType, completion: (() -> Void)? = nil) {
        if let rootViewController = rootViewController {
            rootViewController.dismiss(animated: animated, presentationType: presentationType, completion: completion)
        } else {
            completion?()
        }
    }
}
