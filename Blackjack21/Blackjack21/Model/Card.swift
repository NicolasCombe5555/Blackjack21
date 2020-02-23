//
//  Card.swift
//  Blackjack21
//
//  Created by nicolasCombe on 2/23/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import Foundation

struct Card: CustomStringConvertible {

    var suit: Suit
    var rank: Rank
    var description: String { return "\(rank)\(suit)"}

    enum Suit: String, CustomStringConvertible {

        var description: String {return rawValue}

        case spades = "♠️"
        case hearts = "♥️"
        case clubs = "♣️"
        case diamonds = "♦️"

        static var all = [Suit.spades, .hearts, .diamonds, .clubs]
    }

    enum Rank: Int, CustomStringConvertible {

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

        var description: String {
            switch self {
            case .ace: return "A"
            case .two: return "2"
            case .three: return "3"
            case .four: return "4"
            case .five: return "5"
            case .six: return "6"
            case .seven: return "7"
            case .eight: return "8"
            case .nine: return "9"
            case .ten: return "10"
            case .jack: return "J"
            case .queen: return "Q"
            case .king: return "K"
            }
        }

        static var all: [Rank] {
            return [Rank.ace, .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king]
        }
    }
}
