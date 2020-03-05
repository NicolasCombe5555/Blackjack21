//
//  BlackjackViewController.swift
//  Blackjack21
//
//  Created by nicolasCombe on 2/23/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import UIKit

protocol Dealer: class {
    func updateUI(state: State)
    func updateCounters(for type: Int8)
}

class BlackjackViewController: UIViewController {

    private var myView = GameView()
    private let blackjackBrain = BlackjackBrain()
    private var playerHand: UInt8 = 0
    private var dealerHand: UInt8 = 0

    override func loadView() {
        setUpView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }

    private func startGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.myView.drawCardForPlayer()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            self.myView.drawCardForDealer(isFirstCard: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.6) {
            self.myView.drawCardForPlayer()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.myView.drawCardForDealer()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.9) {
            self.myView.hitButton.isEnabled = true
            self.myView.standButton.isEnabled = true
        }
    }

    @objc private func endGame() {
        guard let firstDealerCard = myView.dealerCards.first else { return }
        myView.standButton.isEnabled = false
        myView.hitButton.isEnabled = false
        myView.dealerHandLabel.isHidden = false
        UIView.transition(with: firstDealerCard, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
            firstDealerCard.isFaceUp = !firstDealerCard.isFaceUp
        })
    }

    @objc private func restartGame() {
        myView = GameView()
        setUpView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.startGame() }

    }

    private func setUpView() {
        view = myView
        myView.delegate = self
        myView.standButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        myView.standButton.isEnabled = true
        myView.dealerHandLabel.isHidden = true
    }
}

extension BlackjackViewController: Dealer {
    func updateUI(state: State) {
        switch state {
        case .busted:
            myView.playerHandLabel.textColor = .systemRed
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.myView.playerHandLabel.transform = CGAffineTransform(scaleX: 2, y: 2)

            }) { _ in
                UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                    self.myView.playerHandLabel.transform = .identity
                }) { _ in
                    self.endGame()
                }
            }
        case .blackjack:
            myView.playerHandLabel.textColor = .systemGreen
            endGame()
        default:
            return
        }
    }

    func updateCounters(for type: Int8) {
        switch type {
        case 1:
            let response = blackjackBrain.calculateHand(with: myView.playerCards)
            myView.playerHandLabel.text = response
            updateUI(state: blackjackBrain.checkHand(Int(response) ?? 0))
        case 2:
            myView.dealerHandLabel.text = blackjackBrain.calculateHand(with: myView.dealerCards)
        default:
            return
        }
    }
}
