//
//  CGRectExtensions.swift
//  Blackjack21
//
//  Created by nicolasCombe on 3/3/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import UIKit

extension CGRect {

    var leftHalf: CGRect {
        CGRect(x: minX, y: minY, width: width/2, height: height)
    }

    var rightHalf: CGRect {
        CGRect(x: midX, y: minY, width: width/2, height: height)
    }

    func inset(by size: CGSize) -> CGRect {
        insetBy(dx: size.width, dy: size.height)
    }

    func sized(to size: CGSize) -> CGRect {
        CGRect(origin: origin, size: size)
    }

    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width-newWidth) / 2, dy: (height-newHeight) / 2)
    }

}

extension CGPoint {

    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        CGPoint(x: x + dx, y: y + dy)
    }

}
