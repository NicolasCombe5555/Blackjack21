//
//  CardView.swift
//  Blackjack21
//
//  Created by nicolasCombe on 2/23/20.
//  Copyright © 2020 Nicolas Combe. All rights reserved.
//

import UIKit

class CardView: UIView {

    var rank: Int = 8
    var suit: String = "♣️"
    var isFaceUp: Bool = false { didSet {setNeedsDisplay(); setNeedsLayout() } }

    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    private var cornerString : NSAttributedString{
        return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }

    private func centeredAttributedString(_ string: String , fontSize : CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle,.font:font])
    }

    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }

    private func configureCornerLabel(_ label :UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        configureCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.transform = CGAffineTransform.identity.translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height).rotated(by: CGFloat.pi)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY).offsetBy(dx: -cornerOffset, dy: -cornerOffset).offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
    }

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        if isFaceUp {
            if let faceCardImage = UIImage(named: rankString+suit) {
                faceCardImage.draw(in: bounds.zoom(by: Constants.faceCardImageSizeToBoundsSize))
            } else {
                pintarCarta()
            }
        }
        else {
            if let cardBackImage = UIImage(named : "backImage", in : Bundle(for:self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
            }
        }
    }
    private func pintarCarta() {
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]

        func createPipString(thatFits pipRect:CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0){ max($1.count , $0)})
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0){ max($1.max() ?? 0 , $0)})
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsperRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipstring = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsperRow.count)
            pipRect.size.height = pipstring.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipcount in pipsperRow {
                switch pipcount {
                case 1 : pipstring.draw(in: pipRect)
                case 2:
                    pipstring.draw(in: pipRect.leftHalf)
                    pipstring.draw(in: pipRect.rightHalf)
                default : break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
}

extension CardView {
    private struct Constants {
        static let cornerFontSizeBoundsHeight : CGFloat = 0.085
        static let cornerRadiusSizeBoundsHeight : CGFloat = 0.06
        static let cornerOffsetToCornerRadius : CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize : CGFloat = 0.75
    }
    private var cornerRadius : CGFloat {
        return bounds.size.height * Constants.cornerRadiusSizeBoundsHeight
    }
    private var cornerOffset : CGFloat {
        return cornerRadius * Constants.cornerOffsetToCornerRadius
    }
    private var cornerFontSize : CGFloat {
        return bounds.size.height * Constants.cornerFontSizeBoundsHeight
    }
    private var rankString : String {
        switch rank {
        case 1 : return "A"
        case 2...10 : return String(rank)
        case 11 : return "J"
        case 12 : return "Q"
        case 13 : return "K"
        default: return "?"
        }
    }
}
