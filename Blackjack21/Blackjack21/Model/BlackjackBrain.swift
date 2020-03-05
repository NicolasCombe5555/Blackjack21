//
//  BlackjackBrain.swift
//  Blackjack21
//
//  Created by nicolasCombe on 3/5/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import Foundation

enum State {
    case blackjack
    case busted
    case normal
}
struct BlackjackBrain {
    
    func calculateHand(with cardViews: [CardView]) -> String {
        let copy = cardViews.map { $0.rank }
        let fixedCopy = copy.replacingMultipleOccurrences(of: 11, 12, 13, with: 10)
        let normalHand = fixedCopy.reduce(0, { $0 + $1 })
        if !fixedCopy.contains(1) {
            return "\(normalHand)"
        } else {
            let handIfAce = fixedCopy.replacingMultipleOccurrences(of: 1, with: 11).reduce(0, { $0 + $1 })
            switch (normalHand, handIfAce) {
            case (_, 21..<100): // handIfAce > 21
                print("1")
                return "\(normalHand)"
            case (21..<100, _): // normalHand > 21
                print("2")
                return "\(handIfAce)"
            case (..<21, ..<21): // handIfAce <= 21 normalHand <= 21
                print("3")
                return "\(normalHand)/\(handIfAce)"
            case (21..<100, 21..<100): // handIfAce > 21 normalHand > 21
                print("4")
                let lowest = min(normalHand, handIfAce)
                return "\(lowest)"
            default:
                return "\(normalHand)"
            }
        }
    }
    
    func checkHand(_ hand: Int) -> State {
        if hand > 21 { return .busted }
        else if hand == 21 { return .blackjack }
        else { return .normal }

    }
}
