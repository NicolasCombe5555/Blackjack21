//
//  CardDeck.swift
//  Blackjack21
//
//  Created by nicolasCombe on 2/23/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import Foundation

struct PlayingCardDeck {

    private(set) var cards = [PlayingCard]()

    init() {
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
   mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: Int.random(in: 0..<cards.count))
        } else {
            return nil
        }
    }
}
