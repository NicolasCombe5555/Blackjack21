//
//  CustomPresent.swift
//  RepasoUlima
//
//  Created by nicolasCombe on 8/31/19.
//  Copyright © 2019 nicolasCombe. All rights reserved.
//
import UIKit

protocol Modal {
    func show(animated: Bool, onView: UIView)
    func dismiss(animated: Bool)
    var backgroundView: UIView { get }
    var dialogView: UIView { get }
}

extension Modal where Self: UIView {

    func show(animated: Bool, onView: UIView) {
        backgroundView.alpha = 0
        dialogView.center = CGPoint(x: center.x, y: frame.height + dialogView.frame.height/2)
        onView.addSubview(self)

        if animated {
            UIView.animate(withDuration: 0.33) { self.backgroundView.alpha = 0.66 }
            UIView.animate(
                withDuration: 0.33,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 10,
                options: UIView.AnimationOptions(rawValue: 0)) { self.dialogView.center  = self.center }
        } else {
            backgroundView.alpha = 0.66
            dialogView.center  = center
        }
    }

    func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.33) { self.backgroundView.alpha = 0 }
            UIView.animate(
                withDuration: 0.33,
                delay: 0, usingSpringWithDamping: 1,
                initialSpringVelocity: 10,
                options: UIView.AnimationOptions(rawValue: 0),
                animations: {
                    self.dialogView.center = CGPoint(
                        x: self.center.x,
                        y: self.frame.height + self.dialogView.frame.height/2
                    )
                }, completion: { _ in
                    self.removeFromSuperview()
                })
        } else {
            removeFromSuperview()
        }
    }

}
