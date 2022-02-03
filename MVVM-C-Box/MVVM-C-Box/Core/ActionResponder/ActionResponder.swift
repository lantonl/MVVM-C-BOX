//
//  ActionResponder.swift
//  MVVM-C-Box
//
//  Created by Anton Gutkin on 28.01.2022.
//

import Foundation

protocol Action {
    var sender: Any? {get}
    var userInfo: [String: Any] {get}
}

protocol ActionResponder: AnyObject {
    var nextActionResponder: ActionResponder? {get set} // !!! ACTION RESPONDER CHAIN USUALLY USED FOR BACKWARD OBJECTS CONNECTION, SO BE SURE ITS DECLARED AS A WEAK PROPERTY IN CLASS THAT CONFORMS TO PROTOCOL TO AVOID STRONG RETAIN CYCLE
    func handleAction(_ action: Action)
}

extension ActionResponder {
    func handleAction(_ action: Action) {
        nextActionResponder?.handleAction(action)
    }
}
