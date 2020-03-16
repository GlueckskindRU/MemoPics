//
//  UIView.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 25.11.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

extension UIView {
    func wasTapInside(by recognizer: UITapGestureRecognizer) -> Bool {
        let tapLocation = recognizer.location(in: self)
        
        return ( tapLocation.x >= self.frame.minX
              && tapLocation.x <= self.frame.maxX
              && tapLocation.y >= self.frame.minY
              && tapLocation.y <= self.frame.maxY
        )
    }
    
    func shake() {
        let finalPosition = self.center
        
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shakeAnimation.values = [0, 10, -10, 10, -5, 5, -5, 0]
        shakeAnimation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.8, 1]
        shakeAnimation.duration = 0.4
        self.layer.add(shakeAnimation, forKey: "shake")
        self.layer.position = finalPosition
    }
    
    func sizeAnimatedTransformation(to finishingScale: Int, with frequencyPerSecond: CFTimeInterval) {
        let transformAnimation = CABasicAnimation(keyPath: "transform.scale")
        transformAnimation.fromValue = 1
        transformAnimation.toValue = finishingScale
        transformAnimation.duration = frequencyPerSecond
        transformAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transformAnimation.repeatCount = 1.0 / Float(frequencyPerSecond)
        transformAnimation.autoreverses = true
        
        self.layer.add(transformAnimation, forKey: "transform")
    }
    
    func removeSubviews<T: UIView>(of subviewClass: T.Type) {
        for subview in self.subviews where subview is T {
            subview.removeFromSuperview()
        }
    }
    
    func loadingAfterAwaking() -> UIView? {
        guard subviews.isEmpty else {
            return self
        }

        return Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: nil, options: nil)?.first as? UIView
    }
}
