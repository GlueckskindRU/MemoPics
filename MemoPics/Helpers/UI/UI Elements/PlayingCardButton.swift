//
//  PlayingCardButton.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 13.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

final class PlayingCardButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isButtonSelected = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        isButtonSelected = false
    }
    
    public var isButtonSelected: Bool = false {
        didSet {
            if isButtonSelected {
                setButtonAsSelected()
            } else {
                setButtonAsUnselected()
            }
            
            guard
                kind == .nominal,
                let nominal = nominal,
                let pack = pack else {
                    return
            }
            
            if pack == .short && nominal < .six {
                setButtonAsNotEnabled()
            }
        }
    }
    
//    public var isButtonEnabled: Bool = true {
//        didSet {
//            if isButtonEnabled {
//                setButtonAsEnabled()
//            } else {
//                setButtonAsNotEnabled()
//            }
//        }
//    }
    
    public var kind: KindOfPlayingCardButton = .space
    public var nominal: CardsNominal?
    public var suit: CardsSuits?
    public var pack: PackOfCards?
    
    public func setup(with title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        self.tintColor = .black
        setButtonAsUnselected()
    }
    
    private func setButtonAsSelected() {
        backgroundColor = .lightGray
        setTitleColor(.white, for: .normal)
    }
    
    private func setButtonAsUnselected() {
        backgroundColor = .white
        setTitleColor(.black, for: .normal)
    }
    
//    private func setButtonAsEnabled() {
//        setButtonAsUnselected()
//        self.isEnabled = true
//    }
//
    private func setButtonAsNotEnabled() {
        backgroundColor = .clear
        setTitleColor(.gray, for: .normal)
        self.isEnabled = false
    }
}
