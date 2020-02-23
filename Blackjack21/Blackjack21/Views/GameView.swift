//
//  GameView.swift
//  Blackjack21
//
//  Created by nicolasCombe on 2/23/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import UIKit

class GameView: UIView {

    let test = CardView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews() {
        backgroundColor = .green

        addSubview(test)
        test.backgroundColor = .clear
        test.isOpaque = false
        test.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            test.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            test.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            test.heightAnchor.constraint(equalToConstant: 400),
            test.widthAnchor.constraint(equalToConstant: 200),
            ])
    }
}

