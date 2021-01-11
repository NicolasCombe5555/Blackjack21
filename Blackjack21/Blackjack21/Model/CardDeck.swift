//
//  CardDeck.swift
//  Blackjack21
//
//  Created by nicolasCombe on 2/23/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import Foundation

struct CardDeck {

    var cards = [Card]()

    init() {
        for suit in Card.Suit.all {
            for rank in Card.Rank.all {
                cards.append(Card(suit: suit, rank: rank))
            }
        }
    }
   mutating func draw() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: Int.random(in: 0..<cards.count))
        } else {
            return nil
        }
    }
    
}
