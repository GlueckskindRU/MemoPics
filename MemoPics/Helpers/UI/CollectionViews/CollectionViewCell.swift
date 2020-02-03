//
//  CollectionViewCell.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 22.12.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    private var gameInterfaceController: PictureMemoGameInterfaceController?
    
    var gameElement: GameElement?
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        return imageView
    }()
    
    func configureImageView(with image: UIImage) {
        imageView.image = image
    }
    
    func configure(with element: GameElement, gic: PictureMemoGameInterfaceController) {
        self.gameInterfaceController = gic
        self.gameElement = element
        imageView.image = element.getImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    @objc
    private func tapGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        guard
            let gameElement = gameElement,
            let gameInterfaceController = gameInterfaceController else {
            return
        }
        
        if recognizer.state == .ended,
        gameElement.getContainerType() == .whereToGuess {
            gameInterfaceController.tapItemProcessing(element: gameElement, imageView: imageView)
        }
    }
}
