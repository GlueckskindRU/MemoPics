//
//  UILabel.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 07.01.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

extension UILabel {
    func setup(with text: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.textColor = .black
        self.textAlignment = .center
        self.text = text
    }
}
