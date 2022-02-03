//
//  Coordinator.swift
//  MVVM-C-Box
//
//  Created by Anton Gutkin on 28.01.2022.
//

import Foundation
import UIKit

class Coordinator: NSObject, ActionResponder {
    var onFinishBlock: ((Coordinator?) -> Void)?
    var onCancelBlock: ((Coordinator?) -> Void)?
    private(set) var childCoordinators: [Coordinator] = []
    private(set) weak var presenter: Presenter?
    weak var navigationController: Presenter? {
        return presenter as? UINavigationController
    }
    private(set) var presentedControllersStack: [UIViewController] = []
    weak var nextActionResponder: ActionResponder?

    required init(presenter: Presenter? = nil,  onFinishBlock: ((Coordinator?) -> Void)? = nil, onCancelBlock: ((Coordinator?) -> Void)? = nil) {
        super.init()
        self.presenter = presenter
        self.onFinishBlock = onFinishBlock
        self.onCancelBlock = onCancelBlock
        if let navigationController = presenter as? UINavigationController {
            navigationController.delegate = self
        }
    }
    
    convenience init(presenter: Presenter? = nil) {
        self.init(presenter: presenter, onFinishBlock: nil, onCancelBlock: nil)
    }

    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    func restore() {
        start()
    }

    func finish() {
        weak var weakSelf = self
        onFinishBlock?(weakSelf)
    }
    
    func cancel() {
        weak var weakSelf = self
        onCancelBlock?(weakSelf)
    }
    
    func addControllerToPresent(_ controller: UIViewController) {
        for element in presentedControllersStack {
            guard element !== controller else {
                return
            }
        }
        
        presentedControllersStack.append(controller)
    }
    
    func removePresented(controller: UIViewController) {
        presentedControllersStack.removeObject(controller)
    }
    
    func presentedControllers() -> [UIViewController] {
        return presentedControllersStack
    }
    
    func runChildCoordinator(_ coordinator: Coordinator, _ completion: (() -> Void)? = nil) {
        coordinator.onFinishBlock = { [weak self] coordinator in
            guard let coordinator = coordinator else {
                return
            }
            
            self?.removeChildCoordinator(coordinator)
            completion?()
        }
        coordinator.onCancelBlock = { [weak self] coordinator in
            guard let coordinator = coordinator else {
                return
            }
            
            self?.removeChildCoordinator(coordinator)
            completion?()
        }
        addChildCoordinator(coordinator)
        coordinator.nextActionResponder = self
        coordinator.start()
    }

    func addChildCoordinator(_ coordinator: Coordinator) {
        for element in childCoordinators {
            guard element !== coordinator else {
                return
            }
        }
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
            // reset navigation delegate to the last coordinator
            guard let navigationController = coordinator.presenter as? UINavigationController else {
                return
            }
            if let coordinatorNavigationController = presenter as? UINavigationController, coordinatorNavigationController == navigationController {
                navigationController.delegate = self
            } else {
                navigationController.delegate = nil
            }
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }

    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
    
    func performAction(_ action: Action) {
        nextActionResponder?.handleAction(action)
    }
    
    func handleAction(_ action: Action) {
        performAction(action)
    }
}

extension Coordinator {
    static func ==(lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
}

extension Coordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let presenter = presenter as? UINavigationController, presenter == navigationController else {
            return
        }
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(poppedViewController) else {
            return
        }
        
        if presentedControllersStack.last === poppedViewController {
            presentedControllersStack.removeLast()
        }
        
        if presentedControllersStack.isEmpty {
            cancel()
        }
    }
}
