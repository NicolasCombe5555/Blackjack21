//
//  GameView.swift
//  Blackjack21
//
//  Created by nicolasCombe on 2/23/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import UIKit

class GameView: UIView {
    
    private var deck = [CardView]()
    var dealerCards = [CardView]()
    var playerCards = [CardView]()
    weak var delegate: Dealer?
    
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
    
    @objc func drawCardForPlayer(isGameStarting: Bool = false) {
        hitButton.isEnabled = false
        standButton.isEnabled = false
        let drawnCard = deck.popLast() ?? CardView()
        backgroundImageView.addSubview(drawnCard)
        
        UIView.animate(withDuration: 0.5, animations: {
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
            
            UIView.transition(with: drawnCard, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
                drawnCard.isFaceUp = !drawnCard.isFaceUp
            }, completion: { _ in
                if !isGameStarting {
                    self.hitButton.isEnabled = true
                    self.standButton.isEnabled = true
                }
                self.delegate?.checkForBust()
            })
        })
    }
    
    @objc func drawCardForDealer(isFirstCard: Bool = false) {
        let drawnCard = deck.popLast() ?? CardView()
        backgroundImageView.addSubview(drawnCard)
        
        UIView.animate(withDuration: 0.5, animations: {
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
                UIView.transition(with: drawnCard, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
                    drawnCard.isFaceUp = !drawnCard.isFaceUp
                })
            }
        })
    }
}


