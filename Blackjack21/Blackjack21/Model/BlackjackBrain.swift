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
        let fixedCopy = copy.map { [11, 12, 13].contains($0) ? 10 : $0}
        let normalHand = fixedCopy.reduce(0, { $0 + $1 })
        if !fixedCopy.contains(1) {
            return "\(normalHand)"
        } else {
            let handIfAce = fixedCopy.map { $0 == 1 ? 11 : $0}.reduce(0, { $0 + $1 })
            switch (normalHand, handIfAce) {
            case (let a, let b) where a == 21 || b == 21:
                return "\(21)"
            case (_, let b) where b > 21:
                return "\(normalHand)"
            case (let a, _) where a > 21:
                return "\(handIfAce)"
            case (let a, let b) where a < 21 && b < 21:
                return "\(normalHand)/\(handIfAce)"
            case (let a, let b) where a > 21 && b > 21:
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
