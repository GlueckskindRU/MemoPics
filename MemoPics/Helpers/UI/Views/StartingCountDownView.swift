//
//  StartingCountDownView.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 07.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class StartingCountDownView: UIView {
    var startingCountDown: Int = 3
    var delegate: StartingCountDownViewDelegate?
    
    private var countDownTimer: Timer?
    
    lazy private var countDownLabel: UILabel = {
        let label = UILabel()
        
        label.setup(with: "\(startingCountDown)")
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = ColorNames.mainAppColor.getColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startCountDown() {
        setupLayout()
        
        countDownLabelAnimation()
        if countDownTimer == nil {
            let timer = Timer(timeInterval: 1, target: self, selector: #selector(countDownLabelUpdate), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            countDownTimer = timer
        }
    }
    
    private func setupLayout() {
        addSubview(countDownLabel)
        
        NSLayoutConstraint.activate([
            countDownLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countDownLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func countDownLabelAnimation() {
        countDownLabel.sizeAnimatedTransformation(to: 15, with: 1)
    }
    
    @objc
    private func countDownLabelUpdate() {
        startingCountDown -= 1
        
        countDownLabel.text = "\(startingCountDown)"
        countDownLabelAnimation()
        
        if startingCountDown == 0 {
            countDownTimer?.invalidate()
            delegate?.startingCountDownViewDismiss()
        }
    }
}
