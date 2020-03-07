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
    func calculateWinner(dealerHand: Int)
}

class BlackjackViewController: UIViewController {

    private var myView = GameView()
    private let blackjackBrain = BlackjackBrain()
    private var playerHand = 0

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
    //Workaround passing argument to buttons function
    @objc private func endGameC() {
        endGame(state: 3)
    }

    private func endGame(state: Int) {
        print(state)
        guard let firstDealerCard = myView.dealerCards.first else { return }
        myView.standButton.isEnabled = false
        myView.hitButton.isEnabled = false
        myView.dealerHandLabel.isHidden = false
        playerHand = stand(text: myView.playerHandLabel.text ?? "")
        UIView.transition(with: firstDealerCard, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
            firstDealerCard.isFaceUp = !firstDealerCard.isFaceUp
        })
        switch state {
        case 1: // bust
            print("gano la casa")
            // mostrar popup
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self.restartGame() }
        case 2: // blackjack
            print("gano jugador")
            // mostrar popup
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self.restartGame() }
        case 3:
            let dealerHand = stand(text: myView.dealerHandLabel.text ?? "")
            print(dealerHand)
            if dealerHand <= 16 {
                myView.drawCardForDealer(isFirstCard: false, isFinishingGame: true)
            } else {
                calculateWinner(dealerHand: dealerHand)
            }
        default:
            return
        }
    }

    @objc private func restartGame() {
        myView = GameView()
        setUpView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.startGame() }

    }

    private func setUpView() {
        view = myView
        myView.delegate = self
        myView.standButton.addTarget(self, action: #selector(endGameC), for: .touchUpInside)
        myView.standButton.isEnabled = true
        myView.dealerHandLabel.isHidden = true
    }

    private func stand(text: String) -> Int {
        let array = text.split(separator: "/")
        if array.count == 2 {
            let ints = array.map { Int($0) ?? 0}
            return ints.max() ?? 0
        } else {
            return Int(text) ?? 0
        }
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
                    self.endGame(state: 1)
                }
            }
        case .blackjack:
            myView.playerHandLabel .textColor = .systemGreen
            endGame(state: 2)
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

    func calculateWinner(dealerHand: Int) {
        switch dealerHand {
        case let number where number == self.playerHand:
            print("empate")
            // mostrar popup
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { self.restartGame() }
        case let number where number < self.playerHand:
            print("gano jugador")
            // mostrar popup
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { self.restartGame() }
        case let number where number > 21:
            print("gano jugador")
            // mostrar popup
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { self.restartGame() }
        default:
            print("gano la casa")
            // mostrar popup
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { self.restartGame() }
        }
    }
}
