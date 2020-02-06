//
//  UIButton.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 07.01.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

extension UIButton {
    func setup(with title: String, target: Any?, action: Selector) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
        self.backgroundColor = .white
        self.layer.cornerRadius = LayoutConsts.cornerRadius
    }
    
    func setup(with image: UIImage, target: Any?, action: Selector, tintColor: UIColor) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let buttonImage = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.setImage(buttonImage, for: .normal)
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
        self.tintColor = tintColor
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
