//
//  PlayingCardsCurtainView.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 18.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class PlayingCardsCurtainView: UIView {
    private let settingsController = (UIApplication.shared.delegate as! AppDelegate).settingsController
    private var delegate: PlayingCardsCurtainViewDelegate?
    
    private let gameDifficutyTitles: [String] = [
        "PlayingCardDifficuty.Easy",
        "PlayingCardDifficuty.Medium",
        "PlayingCardDifficuty.Hard"
    ]
    private let packOfCardsTitles: [String] = [
        "PackOfCards.Full",
        "PackOfCards.Short"
    ]
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var cardsPackLabel: UILabel!
    @IBOutlet weak var gameDifficultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var cardsPackSegmentedControl: UISegmentedControl!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        delegate?.goHome()
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        delegate?.startTheGame()
    }
    
    @IBAction func gameDifficultyChanged(_ sender: UISegmentedControl) {
        settingsController.setNewPlayingCardsDifficulty(CardsPlayingDifficulty.allCases[sender.selectedSegmentIndex])
        settingsController.saveSettings()
    }
    
    @IBAction func cardsPackChanged(_ sender: UISegmentedControl) {
        settingsController.setNewPlayingCardsPack(PackOfCards.allCases[sender.selectedSegmentIndex])
        settingsController.saveSettings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }
    
    func configure(with delegate: PlayingCardsCurtainViewDelegate, inside superView: UIView) {
        self.delegate = delegate

        layoutView(inside: superView)
    }
    
    private func setupView() {
        gameDifficultySegmentedControl.removeAllSegments()
        cardsPackSegmentedControl.removeAllSegments()
        resultsLabel.isHidden = true
        
        if #available(iOS 13.0, *) {
            gameDifficultySegmentedControl.selectedSegmentTintColor = .white
            gameDifficultySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
            gameDifficultySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
            
            cardsPackSegmentedControl.selectedSegmentTintColor = .white
            cardsPackSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
            cardsPackSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        }
        
        let savedPlayingCardDifficuty = settingsController.getPlayingCardsDifficulty()
        let savedPackOfCard = settingsController.getPlayingCardsPack()
        
        for index in CardsPlayingDifficulty.allCases.indices {
            gameDifficultySegmentedControl.insertSegment(withTitle: NSLocalizedString(gameDifficutyTitles[index], comment: "SegmentedControl.Title"), at: index, animated: false)
            if CardsPlayingDifficulty.allCases[index] == savedPlayingCardDifficuty {
                gameDifficultySegmentedControl.selectedSegmentIndex = index
            }
        }
        
        for index in PackOfCards.allCases.indices {
            cardsPackSegmentedControl.insertSegment(withTitle: NSLocalizedString(packOfCardsTitles[index], comment: "SegmentedControl.Title"), at: index, animated: false)
            if PackOfCards.allCases[index] == savedPackOfCard {
                cardsPackSegmentedControl.selectedSegmentIndex = index
            }
        }
        
        startButton.setTitle(NSLocalizedString("Start.Button", comment: "Title.Button"), for: .normal)
        startButton.layer.cornerRadius = LayoutConsts.cornerRadius
        settingsView.layer.cornerRadius = LayoutConsts.cornerRadius
        
        settingsLabel.text = NSLocalizedString("Settings.PlayingCards.Difficulty.Title.Label", comment: "Text.Label")
        cardsPackLabel.text = NSLocalizedString("Settings.PlayingCards.PackOfCards.Title.Label", comment: "Text.Label")
    }
    
    private func layoutView(inside superView: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: 32),
            self.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            superView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 32),
            superView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 32),
        ])
    }
}
