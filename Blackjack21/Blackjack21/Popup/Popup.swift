//
//  CustomPopUp.swift
//  RepasoUlima
//
//  Created by nicolasCombe on 8/31/19.
//  Copyright © 2019 nicolasCombe. All rights reserved.
//

import UIKit

protocol DismissCustomPopUp: class {
    func changeUI()
}

class CustomPopUp: UIView, Modal {

    var backgroundView = UIView()
    var dialogView = UIView()
    let titleLabel = UILabel()
    let separatorLineView = UIView()
    let imageView = UIImageView()
    weak var dismissDelegate: DismissCustomPopUp?

    convenience init(title: String, image: UIImage) {
        self.init(frame: UIScreen.main.bounds)
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.8
        addSubview(backgroundView)

        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        dialogView.clipsToBounds = true
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dialogView)

        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.numberOfLines = 0
        dialogView.addSubview(titleLabel)

        if #available(iOS 13, *) { separatorLineView.backgroundColor = UIColor.systemGroupedBackground
        } else { separatorLineView.backgroundColor = UIColor.groupTableViewBackground }
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(separatorLineView)

        imageView.image = image
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(imageView)

        backgroundView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))

        setUpConstraints()
    }

    func setUpConstraints() {
        let padding: CGFloat = 80
        let imageSize: CGFloat = 60

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: 0),

            separatorLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            separatorLineView.heightAnchor.constraint(equalToConstant: 2),
            separatorLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding-8),
            separatorLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding+8),
            separatorLineView.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor, constant: 0),

            imageView.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: 4),
            imageView.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),

            dialogView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            dialogView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            dialogView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            dialogView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            dialogView.heightAnchor.constraint(equalToConstant: 40 + imageSize)
        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTappedOnBackgroundView() {
        dismiss(animated: true)
        self.dismissDelegate?.changeUI()
    }

}
