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

    override func viewDidAppear(_ animated: Bool) {
        startGame()
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

    @objc private func startGame() {
        self.myView.drawCardForPlayer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            self.myView.drawCardForDealer(isFirstCard: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            self.myView.drawCardForPlayer()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.myView.drawCardForDealer()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.9) {
            self.myView.hitButton.isEnabled = true
            self.myView.standButton.isEnabled = true
        }
    }

    @objc private func restartGame() {
        myView = GameView()
        setUpView()
        perform(#selector(startGame), with: nil, afterDelay: 1)
    }

    //Workaround passing argument to buttons function
      @objc private func endGameC() {
          endGame(state: 3)
      }

    private func endGame(state: Int) {
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
            let dealerHand = stand(text: myView.dealerHandLabel.text ?? "")
            let alert = CustomPopUp(title: "Gano la casa con \(dealerHand)", image: UIImage(named: "lose") ?? UIImage())
            alert.dismissDelegate = self
            alert.show(animated: true, onView: self.view)
        case 2: // blackjack
            let alert = CustomPopUp(title: "Gano jugador con 21!", image: UIImage(named: "win") ?? UIImage())
            alert.dismissDelegate = self
            alert.show(animated: true, onView: self.view)
        case 3:
            let dealerHand = stand(text: myView.dealerHandLabel.text ?? "")
            if dealerHand <= 16 {
                myView.drawCardForDealer(isFirstCard: false, isFinishingGame: true)
            } else {
                calculateWinner(dealerHand: dealerHand)
            }
        default:
            return
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
            let alert = CustomPopUp(title: "Empate", image: UIImage(named: "backImage") ?? UIImage())
            alert.dismissDelegate = self
            alert.show(animated: true, onView: self.view)
        case let number where number < self.playerHand:
            let alert = CustomPopUp(title: "Gano jugador con \(playerHand)", image: UIImage(named: "win") ?? UIImage())
            alert.dismissDelegate = self
            alert.show(animated: true, onView: self.view)
        case let number where number > 21:
            let alert = CustomPopUp(title: "Gano jugador con \(playerHand)", image: UIImage(named: "win") ?? UIImage())
            alert.dismissDelegate = self
            alert.show(animated: true, onView: self.view)
        default:
            let alert = CustomPopUp(title: "Gano la casa con \(dealerHand)", image: UIImage(named: "lose") ?? UIImage())
            alert.dismissDelegate = self
            alert.show(animated: true, onView: self.view)
        }
    }
}

extension BlackjackViewController: DismissCustomPopUp {
    func changeUI() {
        perform(#selector(restartGame), with: nil, afterDelay: 0.5)
    }
}
