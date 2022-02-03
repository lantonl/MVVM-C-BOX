//
//  Array+MVVMExtension.swift
//  MVVM-C-Box
//
//  Created by Anton Gutkin on 28.01.2022.
//

import Foundation

extension Array where Element: Equatable{
    mutating func removeObject(_ object: Element) {
        if let index = self.firstIndex(of: object) {
            self.remove(at: index)
        }
    }
}

