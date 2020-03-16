//
//  PlayingCardsButtonsLayout.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 02.03.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

struct PlayingCardsButtonsLayout {
    private let columns: CGFloat = 5
    private let rows: CGFloat = 4
    private let margin: CGFloat = 16
    private let submitButtonHeightCoeff: CGFloat = 1.25
    
    private var nominalButtons: [PlayingCardButton]
    private var suitButtons: [PlayingCardButton]
    private var spaceButtons: [PlayingCardButton]
    private var submitButton: UIButton
    
    private var buttonWidth: CGFloat
    private var buttonHeight: CGFloat
    private var submitButtonWidth: CGFloat
    private var submitButtonHeight: CGFloat
    
    private var verticalMargin: CGFloat
    private var horizontalMargin: CGFloat
    
    init(superView: UIView, nominalButtons: [PlayingCardButton], suitButtons: [PlayingCardButton], spaceButtons: [PlayingCardButton], submitButton: UIButton) {
        self.nominalButtons = nominalButtons
        self.suitButtons = suitButtons
        self.spaceButtons = spaceButtons
        self.submitButton = submitButton
        
        let width = (superView.frame.width - ((columns + 1) * margin)) / columns
        let height = (superView.frame.height - ((rows + 2) * margin)) / (rows + submitButtonHeightCoeff)
        buttonWidth = min(width, height)
        buttonHeight = buttonWidth
        
        if width < height {
            horizontalMargin = margin
            verticalMargin = (superView.frame.height - ((rows + submitButtonHeightCoeff) * buttonHeight) - (2 * margin)) / rows
        } else {
            verticalMargin = margin
            horizontalMargin = (superView.frame.width - (5 * buttonWidth) - (2 * margin)) / (columns - 1)
        }
        
        submitButtonWidth = superView.frame.width - (2 * margin)
        submitButtonHeight = buttonHeight * submitButtonHeightCoeff
    }
    
// MARK: - Public methods
    func performLayout() {
        var x: CGFloat = margin
        var y: CGFloat = margin
        
        //row J_Q_K_A_Spade
        layoutPlayButton(of: .nominal, with: CardsNominal.jack.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .nominal, with: CardsNominal.queen.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .nominal, with: CardsNominal.king.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .nominal, with: CardsNominal.ace.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .suit, with: CardsSuits.spade.getTitle(), x: x, y: y)
        
        //row 7_8_9_10_Clubs
        startNewRow(&x, &y)
        layoutPlayButton(of: .nominal, with: CardsNominal.seven.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .nominal, with: CardsNominal.eigth.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .nominal, with: CardsNominal.nine.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .nominal, with: CardsNominal.ten.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .suit, with: CardsSuits.clubs.getTitle(), x: x, y: y)
        
        //row 3_4_5_6_Diamonds
        startNewRow(&x, &y)
        layoutPlayButton(of: .nominal, with: CardsNominal.three.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .nominal, with: CardsNominal.four.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .nominal, with: CardsNominal.five.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .nominal, with: CardsNominal.six.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .suit, with: CardsSuits.diamonds.getTitle(), x: x, y: y)
        
        //row 2_ _ _ _Hearts
        startNewRow(&x, &y)
        layoutPlayButton(of: .nominal, with: CardsNominal.two.getTitle(), x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .space, with: "", x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .space, with: "", x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .space, with: "", x: x, y: y)
        shift(&x)
        layoutPlayButton(of: .suit, with: CardsSuits.hearts.getTitle(), x: x, y: y)
        
        //submit button
        startNewRow(&x, &y)
        layoutSubmitButton(x, y)
    }

// MARK: - Private methods
    private func getButtonsArray(of kind: KindOfPlayingCardButton) -> [PlayingCardButton] {
        switch kind {
        case .nominal:
            return nominalButtons
        case .space:
            return spaceButtons
        case .suit:
            return suitButtons
        }
    }
    
    private func getPlayButton(of kind: KindOfPlayingCardButton, with title: String) -> PlayingCardButton {
        if let button = getButtonsArray(of: kind).filter( { $0.titleLabel?.text == title } ).first {
            return button
        } else {
            return PlayingCardButton()
        }
    }
    
    private func layoutPlayButton(of kind: KindOfPlayingCardButton, with title: String, x: CGFloat, y: CGFloat) {
        let button = getPlayButton(of: kind, with: title)
        
        button.frame = CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)
        button.layer.cornerRadius = buttonHeight / 2
    }
    
    private func layoutSubmitButton(_ x: CGFloat, _ y: CGFloat) {
        submitButton.frame = CGRect(x: x, y: y, width: submitButtonWidth, height: submitButtonHeight)
        
        submitButton.layer.cornerRadius = submitButtonHeight / 2
    }
    
    private func shift(_ x: inout CGFloat) {
        x += buttonWidth + horizontalMargin
    }
    
    private func startNewRow(_ x: inout CGFloat, _ y: inout CGFloat) {
        x = margin
        y += buttonHeight + verticalMargin
    }
}
