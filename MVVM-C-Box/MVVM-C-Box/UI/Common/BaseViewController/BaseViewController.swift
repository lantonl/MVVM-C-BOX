//
//  BaseViewController.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 17.01.2022.
//

import Foundation
import UIKit

protocol BaseViewControllerProtocol: AnyObject {
    var loadingIndicatorView: UIActivityIndicatorView? { get set }
    
    func show(error: NetworkResponseError)
    func show(message: String, title: String?)
    
    func showLoadingView(on controller: UIViewController)
    func hideLoadingView()
    func set(title: String)
}

class BaseViewController: UIViewController {
    var loadingIndicatorView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

extension BaseViewController: BaseViewControllerProtocol {
    func set(title: String) {
        self.title = title
    }
    
    func show(error: NetworkResponseError) {
        self.show(message: error.description(), title: "Error")
    }
    
    func show(message: String, title: String?) {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let positiveAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        popup.addAction(positiveAction)
        popup.preferredAction = positiveAction
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func showLoadingView(on controller: UIViewController) {
        let loadingIndicatorView = UIActivityIndicatorView(style: .large)
        self.loadingIndicatorView = loadingIndicatorView
        controller.view.addSubviewWithSameSizeConstraints(loadingIndicatorView)
        loadingIndicatorView.startAnimating()
    }
    
    func hideLoadingView() {
        loadingIndicatorView?.removeFromSuperview()
        loadingIndicatorView = nil
    }
}
