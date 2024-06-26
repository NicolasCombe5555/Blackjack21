//
//  CustomPopUp.swift
//  RepasoUlima
//
//  Created by nicolasCombe on 8/31/19.
//  Copyright © 2019 nicolasCombe. All rights reserved.
//

import UIKit

protocol DismissCustomPopUp: AnyObject {
    func updateUI()
}

final class CustomPopUp: UIView, Modal {

    weak var dismissDelegate: DismissCustomPopUp?

    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.8
        return view
    }()

    let dialogView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    let separatorLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13, *) {
            view.backgroundColor = .systemGroupedBackground
        } else {
            view.backgroundColor = .groupTableViewBackground
        }
        return view
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    convenience init(title: String, image: UIImage) {
        self.init(frame: UIScreen.main.bounds)
        backgroundView.frame = frame
        imageView.image = image
        titleLabel.text = title

        addSubview(backgroundView)
        addSubview(dialogView)
        dialogView.addSubview(titleLabel)
        dialogView.addSubview(separatorLineView)
        dialogView.addSubview(imageView)

        addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))

        setUpConstraints()
    }

    @objc func didTappedOnBackgroundView() {
        dismiss(animated: true)
        dismissDelegate?.updateUI()
    }

    func setUpConstraints() {
        let padding: CGFloat = 80
        let imageSize: CGFloat = 70

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor),

            separatorLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            separatorLineView.heightAnchor.constraint(equalToConstant: 2),
            separatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding-8),
            separatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding+8),
            separatorLineView.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor, constant: 0),

            imageView.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: 4),
            imageView.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),

            dialogView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            dialogView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            dialogView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dialogView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dialogView.heightAnchor.constraint(equalToConstant: 40 + imageSize)
        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
