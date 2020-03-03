//
//  GameView.swift
//  Blackjack21
//
//  Created by nicolasCombe on 2/23/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import UIKit

class GameView: UIView {

    let test: CardView = {
        let cardView = CardView()
        cardView.backgroundColor = .clear
        cardView.isOpaque = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "b3")
        return imageView
    }()

    let hitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Carta", for: .normal)
        return button
    }()

    let standButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Parar", for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(test)
        addSubview(hitButton)
        addSubview(standButton)

        NSLayoutConstraint.activate([
            //Background Image
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),

            //Buttons
            standButton.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: 0),
            standButton.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor, constant: -40),
            standButton.heightAnchor.constraint(equalToConstant: 44),
            standButton.widthAnchor.constraint(equalToConstant: 60),

            hitButton.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: 0),
            hitButton.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor, constant: 40),
            hitButton.heightAnchor.constraint(equalToConstant: 44),
            hitButton.widthAnchor.constraint(equalToConstant: 60),

            test.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor, constant: -60),
            test.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -135),
            test.heightAnchor.constraint(equalToConstant: 135),
            test.widthAnchor.constraint(equalToConstant: 85)
        ])
    }
}

