//
//  PlayingCardsGameInterfaceController.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 18.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class PlayingCardsGameInterfaceController {
    fileprivate var gameEngine: PlayingCardsGameEngine
    fileprivate let settingsController = (UIApplication.shared.delegate as! AppDelegate).settingsController
    
    fileprivate var viewController: UIViewController
    fileprivate var keyboardSuperView: UIView
    fileprivate var countingLabel: UILabel
    fileprivate var timingLabel: UILabel
    fileprivate var playingCardsTableView: UIView
    fileprivate var openedCardImageView: UIImageView
    fileprivate var closedCardImageView: UIImageView
    
    fileprivate var openFirstCardButton: UIButton
    
    fileprivate var curtainView: PlayingCardsCurtainView?
    fileprivate var keyboardView: PlayingCardsKeyboardView?
    
    fileprivate var cardsPack: PackOfCards?
    fileprivate var gameDifficulty: CardsPlayingDifficulty?
    
    fileprivate var timer: Timer?
    fileprivate var durationInSeconds: Int = 0
    
    fileprivate var lastCardWasOpened: Bool = false
    
    init(viewController: UIViewController, keyboard: UIView, countingLabel: UILabel, timingLabel: UILabel, playingCardsTableView: UIView, openedCardImageView: UIImageView, closedCardImageView: UIImageView) {
        self.gameEngine = PlayingCardsGameEngine()
        
        self.viewController = viewController
        self.keyboardSuperView = keyboard
        self.countingLabel = countingLabel
        self.timingLabel = timingLabel
        self.playingCardsTableView = playingCardsTableView
        self.openedCardImageView = openedCardImageView
        self.closedCardImageView = closedCardImageView
        
        self.openFirstCardButton = UIButton()
        self.openFirstCardButton.setup(with: NSLocalizedString("OpenFirstCard.Button", comment: "Title.Button"), target: self, action: #selector(openFirstCardButtonTapped(_:)))
        
        configureCurtainView(withResults: false)
        
        curtainView?.isHidden = false
        keyboardSuperView.isHidden = false
        playingCardsTableView.isHidden = true
        countingLabel.isHidden = true
        timingLabel.isHidden = true

        configureOpenFirstCardButton()
    }
    
    private func startNewGame() throws {
        clearingForANewGame()
        refreshSettings()
        configureOpenFirstCardButton()
        
        guard
            let cardsPack = cardsPack,
            let gameDifficulty = gameDifficulty else {
                throw AppError.playingCardSettingsNotAvailable
        }
        
        gameEngine.initNewGame(for: cardsPack, having: gameDifficulty)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timingLabelUpdate), userInfo: nil, repeats: true)
        startNewRound()
    }
    
    private func refreshSettings() {
        cardsPack = settingsController.getPlayingCardsPack()
        gameDifficulty = settingsController.getPlayingCardsDifficulty()
    }
    
    private func clearingForANewGame() {
        durationInSeconds = 0
        timer = nil
        timingLabel.text = "00:00"
        lastCardWasOpened = false
        
        openedCardImageView.image = nil
        closedCardImageView.image = nil
    }
    
    private func startNewRound() {
        func showNextImage(with image: UIImage?) {
            lastCardWasOpened = image == nil
            
            openedCardImageView.image = image
            countingLabel.text = "\(gameEngine.getNumberOfCorrectAnswers()) / \(gameEngine.getTotalPlayedRounds())"
            keyboardView?.clearButtonsSelection()
        }
        
        if lastCardWasOpened {
            keyboardSuperView.removeSubviews(of: PlayingCardsKeyboardView.self)
            keyboardSuperView.removeSubviews(of: PlayingCardButton.self)
            keyboardSuperView.removeSubviews(of: UIButton.self)
            keyboardView = nil
            configureCurtainView(withResults: true)
        } else if let newCard = gameEngine.startNewRound() {
            showNextImage(with: newCard.getImage())
        } else {
            showNextImage(with: nil)
        }
    }
    
    @objc
    private func timingLabelUpdate() {
        durationInSeconds += 1
        timingLabel.text = getPassedTimeInString(durationInSeconds)
    }
    
    @objc
    private func openFirstCardButtonTapped(_ sender: UIButton) {
        closedCardImageView.image = AuxiliaryImageNames.backgroundCard.getImage()
        keyboardSuperView.removeSubviews(of: UIButton.self)
        configureKeyboardView()
        startNewRound()
    }
    
    private func configureOpenFirstCardButton() {
        keyboardSuperView.addSubview(openFirstCardButton)
        
        NSLayoutConstraint.activate([
            openFirstCardButton.topAnchor.constraint(equalTo: keyboardSuperView.topAnchor, constant: 32),
            openFirstCardButton.leadingAnchor.constraint(equalTo: keyboardSuperView.leadingAnchor, constant: 32),
            keyboardSuperView.trailingAnchor.constraint(equalTo: openFirstCardButton.trailingAnchor, constant: 32),
            keyboardSuperView.bottomAnchor.constraint(equalTo: openFirstCardButton.bottomAnchor, constant: 32),
        ])
    }
    
    private func configureKeyboardView() {
        let keyboardView = PlayingCardsKeyboardView(frame: CGRect(x: 4,
                                                                  y: 4,
                                                                  width: keyboardSuperView.frame.width - 8,
                                                                  height: keyboardSuperView.frame.height - 8
                                                    ))
        
        keyboardView.backgroundColor = keyboardSuperView.backgroundColor
        keyboardSuperView.addSubview(keyboardView)
        keyboardView.delegate = self
        keyboardView.layoutButtons(for: settingsController.getPlayingCardsPack())
        
        self.keyboardView = keyboardView
    }
    
    private func configureCurtainView(withResults: Bool) {
        guard let curtainView = Bundle.main.loadNibNamed(String(describing: PlayingCardsCurtainView.self), owner: nil, options: nil)?.first as? PlayingCardsCurtainView else {
            return
        }
        
        curtainView.backgroundColor = viewController.view.backgroundColor
        viewController.view.addSubview(curtainView)
        curtainView.configure(with: self, inside: viewController.view)
        self.curtainView = curtainView
        
        if withResults {
            let text = "\(NSLocalizedString("TotalTime.Label", comment: "Text.Label")): \(getPassedTimeInString(durationInSeconds))\n\(NSLocalizedString("TotalRoundsPlayed.Label", comment: "Text.Label")): \(gameEngine.getTotalPlayedRounds())\n\(NSLocalizedString("TotalSuccessRounds.Label", comment: "Text.Label")): \(gameEngine.getNumberOfCorrectAnswers())"
            curtainView.resultsLabel.isHidden = false
            curtainView.resultsLabel.text = text
        }
    }
    
    private func getPassedTimeInString(_ passedSeconds: Int) -> String {
        let secondsInMinute = 60
        
        let minutes = durationInSeconds / secondsInMinute
        let seconds = durationInSeconds % secondsInMinute
        
        let minutesText = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsText = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        
        return "\(minutesText):\(secondsText)"
    }
}


// MARK: - CurtainView Delegate
extension PlayingCardsGameInterfaceController: PlayingCardsCurtainViewDelegate {
    func goHome() {
        if let homeScreenVC = Bundle.main.loadNibNamed(String(describing: HomeScreenViewController.self), owner: nil, options: nil)?.first as? HomeScreenViewController {
            homeScreenVC.modalTransitionStyle = .crossDissolve
            homeScreenVC.modalPresentationStyle = .fullScreen
            viewController.present(homeScreenVC, animated: true, completion: nil)
        }
    }
    
    func startTheGame() {
        curtainView?.removeFromSuperview()
        keyboardSuperView.isHidden = false
        playingCardsTableView.isHidden = false
        countingLabel.isHidden = false
        timingLabel.isHidden = false
        
        do {
            try startNewGame()
        } catch AppError.playingCardSettingsNotAvailable {
            viewController.showDialog(title: nil, message: AppError.playingCardSettingsNotAvailable.getErrorText())
        } catch {
            viewController.showDialog(title: nil, message: AppError.defaultErrorValue.getErrorText())
        }
    }
}

// MARK: - Keyboard Delegate
extension PlayingCardsGameInterfaceController: PlayingCardsKeyboardDelegate {
    func passSelectedPlayingCard(_ playingCard: PlayingCard) {
        if !gameEngine.isCardGuessed(playingCard) {
            closedCardImageView.shake()
        }
        
        startNewRound()
    }
}
