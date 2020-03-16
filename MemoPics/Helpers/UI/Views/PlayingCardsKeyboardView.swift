//
//  PlayingCardsKeyboardView.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 02.03.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class PlayingCardsKeyboardView: UIView {
    private var nominalButtons: [PlayingCardButton] = []
    private var suitButtons: [PlayingCardButton] = []
    private var spaceButtons: [PlayingCardButton] = []
    
    private var selectedSuit: CardsSuits?
    private var selectedNominal: CardsNominal?
    
    var delegate: PlayingCardsKeyboardDelegate?
    
    lazy private var submitButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(NSLocalizedString("Submit.Button", comment: "Title.Button"), for: .normal)
        button.addTarget(self, action: #selector(submitButtontapped(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = .black
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("there is no init from the XIB")
    }
    
    private func createButtons() {
        createSuitButtons()
        createNominalButtons()
        createSpaceButtons()
    }
    
    private func createSpaceButtons() {
        for _ in 0...2 {
            createSpaceButton()
        }
    }
    
    private func createNominalButtons() {
        let settingController = SettingsController()
        for nominal in CardsNominal.allCases {
            createNominalButton(of: nominal, pack: settingController.getPlayingCardsPack())
        }
    }
    
    private func createSuitButtons() {
        for suit in CardsSuits.allCases {
            createSuitButton(of: suit)
        }
    }
    
    private func createNominalButton(of nominal: CardsNominal, pack: PackOfCards) {
        let newButton = PlayingCardButton()
        newButton.setup(with: nominal.getTitle())
        newButton.addTarget(self, action: #selector(nominalButtonTapped(_:)), for: .touchUpInside)
        newButton.kind = .nominal
        newButton.nominal = nominal
        newButton.pack = pack
        nominalButtons.append(newButton)
    }
    
    private func createSuitButton(of suit: CardsSuits) {
        let newButton = PlayingCardButton()
        newButton.setup(with: suit.getTitle())
        newButton.addTarget(self, action: #selector(suitButtonTapped(_:)), for: .touchUpInside)
        newButton.kind = .suit
        newButton.suit = suit
        suitButtons.append(newButton)
    }
    
    private func createSpaceButton() {
        let newButton = PlayingCardButton()
        newButton.setup(with: "")
        newButton.kind = .space
        spaceButtons.append(newButton)
    }
    
    func layoutButtons(for pack: PackOfCards) {
        guard let superView = superview else {
            return
        }
        
        superView.addSubview(submitButton)
        nominalButtons.forEach( { superView.addSubview($0) } )
        suitButtons.forEach( { superView.addSubview($0) } )
        spaceButtons.forEach( { superView.addSubview($0) } )
        
        let layoutHelper = PlayingCardsButtonsLayout(superView: superView,
                                                     nominalButtons: nominalButtons,
                                                     suitButtons: suitButtons,
                                                     spaceButtons: spaceButtons,
                                                     submitButton: submitButton
                                                    )
        layoutHelper.performLayout()
    }
    
    func clearButtonsSelection() {
        nominalButtons.forEach( { $0.isButtonSelected = false } )
        suitButtons.forEach( { $0.isButtonSelected = false } )
    }
    
    @objc
    private func nominalButtonTapped(_ sender: PlayingCardButton) {
        guard
            sender.kind == .nominal,
            let nominal = sender.nominal else {
                return
        }
        
        selectedNominal = nominal
        nominalButtons.forEach( { $0.isButtonSelected = false } )
        sender.isButtonSelected = true
    }
    
    @objc
    private func suitButtonTapped(_ sender: PlayingCardButton) {
        guard
            sender.kind == .suit,
            let suit = sender.suit else {
                return
        }
        
        selectedSuit = suit
        suitButtons.forEach( { $0.isButtonSelected = false } )
        sender.isButtonSelected = true
    }
    
    @objc
    private func submitButtontapped(_ sender: UIButton) {
        guard
            let selectedNominal = selectedNominal,
            let selectedSuit = selectedSuit else {
                return
        }
        
        let selectedPlayingCard = PlayingCard(suit: selectedSuit, nominal: selectedNominal)
        delegate?.passSelectedPlayingCard(selectedPlayingCard)
    }
}
