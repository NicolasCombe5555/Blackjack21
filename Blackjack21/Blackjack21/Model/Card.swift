//
//  Card.swift
//  Blackjack21
//
//  Created by nicolasCombe on 2/23/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import Foundation

struct Card: CustomStringConvertible {

    var description: String { return "\(rank)\(suit)"}
    var suit: Suit
    var rank: Rank


    enum Suit: String, CustomStringConvertible {

        var description: String {return rawValue}

        case spades = "♠️"
        case hearts = "♥️"
        case clubs = "♣️"
        case diamonds = "♦️"

        static var all = [Suit.spades, .hearts, .diamonds, .clubs]
    }

    enum Rank: Int, CustomStringConvertible {

        var description: String { return "\(self.rawValue)" }

        case ace = 1
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case jack
        case queen
        case king

        static var all: [Rank] {
            return [Rank.ace, .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king]
        }
    }
}
