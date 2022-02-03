//
//  ActionType.swift
//  MVVM-C-Box
//
//  Created by Anton Gutkin on 28.01.2022.
//

import Foundation
import UIKit


enum PageType {
    case movieDetails
}

enum ActionType {
    case push
    case show(presentationStyle: UIModalPresentationStyle? = nil)
}

extension ActionType: Equatable {
    static func == (lhs: ActionType, rhs: ActionType) -> Bool {
        switch (lhs, rhs) {
        case (.push, .push): return true
        case (.show, .show): return true
        default: return false
        }
    }
}

struct GenericActionKey {
    static let destinationPage: String = "destinationPage"
    static let destinationLink: String = "destinationLink"
    static let nestedObject: String = "nestedObject"
}

struct GenericAction: Action {
    var type: ActionType
    var sender: Any?
    var userInfo: [String: Any]
    var completionHandler: (() -> Void)? = nil

    init(_ type: ActionType, _ sender: Any? = nil, _ userInfo: [String: Any] = [String: Any]()) {
        self.type = type
        self.sender = sender
        self.userInfo = userInfo
    }
}
