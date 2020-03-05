//
//  ArrayExtensions.swift
//  Blackjack21
//
//  Created by nicolasCombe on 3/5/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func replacingMultipleOccurrences(of: Element..., with: Element) -> Array {
        var newArr: Array<Element> = self
        
        for (index, item) in self.enumerated() {
            if of.contains(item) {
                newArr[index] = with
            }
        }
        return newArr
    }
}
