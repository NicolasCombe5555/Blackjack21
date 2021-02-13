//
//  GameView.swift
//  Blackjack21
//
//  Created by nicolasCombe on 2/23/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import UIKit

final class GameView: UIView {

    private var deck = [CardView]()
    var dealerCards = [CardView]()
    var playerCards = [CardView]()
    weak var delegate: DealerDelegate?

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

    let dealerHandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        return label
    }()

    let playerHandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
        addCards()
        setUpButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        addSubview(backgroundImageView)
        addSubview(hitButton)
        addSubview(standButton)
        addSubview(dealerHandLabel)
        addSubview(playerHandLabel)

        NSLayoutConstraint.activate([
            //Background Image
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            //Buttons
            standButton.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
            standButton.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor, constant: -40),
            standButton.heightAnchor.constraint(equalToConstant: 44),
            standButton.widthAnchor.constraint(equalToConstant: 60),

            hitButton.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
            hitButton.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor, constant: 40),
            hitButton.heightAnchor.constraint(equalToConstant: 44),
            hitButton.widthAnchor.constraint(equalToConstant: 60),

            //Labels
            dealerHandLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            dealerHandLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 60),

            playerHandLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            playerHandLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -60)
        ])
    }

    private func setUpButtons() {
        hitButton.addTarget(self, action: #selector(drawCardForPlayer), for: .touchUpInside)
        hitButton.isEnabled = false
        standButton.isEnabled = false
    }

    private func addCards() {
        var cardDeck = CardDeck()
        cardDeck.cards.shuffle()
        for card in cardDeck.cards {
            let cardView = CardView(frame: CGRect(x: (UIScreen.main.nativeBounds.width / UIScreen.main.scale) - 100, y: 15, width: 85, height: 135))
            cardView.rank = Int(card.rank.description) ?? 0
            cardView.suit = card.suit.description
            cardView.backgroundColor = .clear
            cardView.isOpaque = false
            cardView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(cardView)
            cardView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
            deck.append(cardView)
        }
    }

    @objc func drawCardForPlayer() {
        hitButton.isEnabled = false
        standButton.isEnabled = false
        let drawnCard = deck.popLast() ?? CardView()
        backgroundImageView.addSubview(drawnCard)

        UIView.animate(withDuration: 0.75, animations: {
            NSLayoutConstraint.activate([
                drawnCard.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor, constant: -60 + (30 * CGFloat(self.playerCards.count))),
                drawnCard.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor, constant: -135),
                drawnCard.heightAnchor.constraint(equalToConstant: 135),
                drawnCard.widthAnchor.constraint(equalToConstant: 85)
            ])
            drawnCard.transform = CGAffineTransform(rotationAngle: 0)
            self.layoutIfNeeded()

        }, completion: { _ in
            self.playerCards.append(drawnCard)

            UIView.transition(with: drawnCard, duration: 0.75, options: [.transitionFlipFromLeft], animations: {
                drawnCard.isFaceUp = !drawnCard.isFaceUp
            }, completion: { _ in
                if self.playerCards.count >= 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                        self.hitButton.isEnabled = true
                        self.standButton.isEnabled = true
                    }
                }
                self.delegate?.updateCounters(for: 1)
            })
        })
    }

    @objc func drawCardForDealer(isFirstCard: Bool = false, isFinishingGame: Bool = false) {
        hitButton.isEnabled = false
        standButton.isEnabled = false
        let drawnCard = deck.popLast() ?? CardView()
        backgroundImageView.addSubview(drawnCard)

        UIView.animate(withDuration: 0.75, animations: {
            NSLayoutConstraint.activate([
                drawnCard.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor, constant: -60 + (30 * CGFloat(self.dealerCards.count))),
                drawnCard.topAnchor.constraint(equalTo: self.backgroundImageView.topAnchor, constant: 135),
                drawnCard.heightAnchor.constraint(equalToConstant: 135),
                drawnCard.widthAnchor.constraint(equalToConstant: 85)
            ])
            drawnCard.transform = CGAffineTransform(rotationAngle: 0)
            self.layoutIfNeeded()

        }, completion: { _ in
            self.dealerCards.append(drawnCard)
            if !isFirstCard {
                UIView.transition(with: drawnCard, duration: 0.75, options: [.transitionFlipFromLeft], animations: {
                    drawnCard.isFaceUp = !drawnCard.isFaceUp
                }, completion: { _ in
                    self.delegate?.updateCounters(for: 2)
                    if isFinishingGame {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            let dealerHand = self.stand(text: self.dealerHandLabel.text ?? "")
                            if  dealerHand <= 16 {
                                self.drawCardForDealer(isFirstCard: false, isFinishingGame: true)
                            } else {
                                self.delegate?.calculateWinner(dealerHand: dealerHand)
                            }
                        }
                    }
                })
            }
        })
    }

}

private extension GameView {

    func stand(text: String) -> Int {
        let array = text.split(separator: "/")
        if array.count == 2 {
            let choices = array.map { Int($0) ?? 0}
            return choices.max() ?? 0
        } else {
            return Int(text) ?? 0
        }
    }

}
