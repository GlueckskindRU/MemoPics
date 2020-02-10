//
//  PictureMemoGameInterfaceController.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 25.11.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class PictureMemoGameInterfaceController {
// MARK: - Properties
    fileprivate let gameEngine: PictureMemoGameEngine
    fileprivate let memorizedButton: UIButton
    fileprivate let startButton: UIButton
    fileprivate let homeButton: UIButton
    fileprivate let roundsLabel: UILabel
    fileprivate let countDownLabel: UILabel
    fileprivate let totalsLabel: UILabel
    fileprivate let whatContainerView: UIView
    fileprivate let whereContainerView: UIView
    fileprivate let topAuxiliaryView: UIView
    fileprivate let bottomAuxiliaryView: UIView
    fileprivate let curtainView: UIView
    fileprivate let viewController: UIViewController
    
    fileprivate var whatCollectionView: UICollectionView?
    fileprivate var whereCollectionView: UICollectionView?
    fileprivate var whatCollectionViewDataSource: CollectionViewDataSource?
    fileprivate var whereCollectionViewDataSource: CollectionViewDataSource?
    
    fileprivate let settingsController = (UIApplication.shared.delegate as! AppDelegate).settingsController
    fileprivate var gameDuration: GameDurations
    
    fileprivate var gameTimer: Timer?
    fileprivate var countDownTimer: Timer?
    fileprivate var seconds: Int
    
    fileprivate var startingCountDownView: StartingCountDownView?
    
    lazy fileprivate var settingsView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = LayoutConsts.cornerRadius
        
        return view
    }()
    
    lazy fileprivate var settingsTitleLabel: UILabel = {
        let label = UILabel()
        
        label.setup(with: NSLocalizedString("SettingsTitle.Label", comment: "Text.Label"))
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy fileprivate var durationSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        
        control.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            control.selectedSegmentTintColor = .white
            control.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .normal)
            control.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .selected)
        }
        var i = 0
        let currentDuration = settingsController.getGameDuration()
        for duration in GameDurations.allCases {
            control.insertSegment(withTitle: "\(duration.rawValue)", at: i, animated: false)
            if duration == currentDuration {
                control.selectedSegmentIndex = i
            }
            i += 1
        }
        control.addTarget(self, action: #selector(durationSegmentedControlChanged(sender:)), for: .valueChanged)
        
        return control
    }()
    
// MARK: - Initialization
    init(whatContainerView: UIView, whereContainerView: UIView, viewController: UIViewController, topAuxiliaryView: UIView, bottomAuxiliaryView: UIView, curtainView: UIView) {
        self.whatContainerView = whatContainerView
        self.whereContainerView = whereContainerView
        self.topAuxiliaryView = topAuxiliaryView
        self.bottomAuxiliaryView = bottomAuxiliaryView
        self.curtainView = curtainView

        self.viewController = viewController

        self.gameEngine = PictureMemoGameEngine()
        self.gameDuration = settingsController.getGameDuration()
        
        self.memorizedButton = UIButton()
        self.homeButton = UIButton()
        self.startButton = UIButton()
        self.roundsLabel = UILabel()
        self.countDownLabel = UILabel()
        self.totalsLabel = UILabel()
        
        self.seconds = gameDuration.rawValue
        
        memorizedButton.setup(with: NSLocalizedString("Memorized.Button", comment: "Title.Button"), target: self, action: #selector(memorizedButtonTapped(sender:)))
        setupMemorizedButtonLayout()
        
        startButton.setup(with: NSLocalizedString("Start.Button", comment: "Title.Button"), target: self, action: #selector(startButtonTapped(sender:)))
        setupCurtainViewLayout()
        
        homeButton.setup(with: AuxiliaryImageNames.homeIcon.getImage(), target: self, action: #selector(homeButtonTapped(sender:)), tintColor: .white)
        setupHomeButtonLayout()
        
        roundsLabel.setup(with: "")
        setupRoundsLabelLayout()
        
        let countDownText = seconds == 60 ? "01:00" : "00:\(seconds)"
        countDownLabel.setup(with: countDownText)
        setupCountDownLabelLayout()
        
        totalsLabel.setup(with: "")
        totalsLabel.numberOfLines = 4
        setupTotalsLabelLayout()
    }
    
// MARK: - Public Functions
    func tapItemProcessing(element: GameElement, imageView: UIImageView) {
        if gameEngine.isElementToBeGuessed(element.getItem()) {
            if gameEngine.isAlreadyGuessed(element.getItem()) {
                falseTapProcessing(of: imageView)
            } else {
                showGuessedItemInWhatCollectionView(element)
            }
            
            gameEngine.increaseNumberOfGuessedItems(for: element.getItem())
            if gameEngine.isRoundFinished() {
                UIDevice.vibrate()
                gameEngine.finishCurrentRound()
                do {
                    try startNewRound()
                } catch AppError.incorrectCountValue {
                    viewController.showDialog(title: nil, message: AppError.incorrectCountValue.getErrorText())
                } catch AppError.whereContainerCountIsLessWhanWhatContainerCount {
                    viewController.showDialog(title: nil, message: AppError.whereContainerCountIsLessWhanWhatContainerCount.getErrorText())
                } catch {
                    viewController.showDialog(title: nil, message: AppError.defaultErrorValue.getErrorText())
                }
            }
        } else {
            falseTapProcessing(of: imageView)
        }
    }
}

// MARK: - Game Related Functions
extension PictureMemoGameInterfaceController {
    fileprivate func startNewGame() throws {
        try gameEngine.initNewGame(for: gameDuration)
        
        indicateStartingCountDownView(startValue: 3)
    }
    
    fileprivate func startNewRound() throws {
        try gameEngine.initRound()
        
        setupNewRound()
    }
    
    fileprivate func setupNewRound() {
        cleaningContainers()
        
        createWhatCollectionView()
        setupWhatContainerViewLayout()
        
        createWhereCollectionView()
        setupWhereContainerViewLayout()
        
        whereCollectionView?.isHidden = true
        memorizedButton.isHidden = false
        roundsLabel.isHidden = true
    }
    
    fileprivate func cleaningContainers() {
        if !whatContainerView.subviews.isEmpty {
            whatContainerView.removeSubviews(of: UICollectionView.self)
        }
        
        whatCollectionView = nil
        whatCollectionViewDataSource = nil
        
        if !whereContainerView.subviews.isEmpty {
            whereContainerView.removeSubviews(of: UICollectionView.self)
        }
        
        whereCollectionView = nil
        whereCollectionViewDataSource = nil
    }
    
    fileprivate func refreshGameDuration() {
        gameDuration = settingsController.getGameDuration()
        seconds = gameDuration.rawValue
        countDownLabel.text = seconds == 60 ? "01:00" : "00:\(seconds)"
    }
    
    fileprivate func indicateStartingCountDownView(startValue: Int) {
        let startingCountDownView = StartingCountDownView(frame: self.viewController.view.frame)
        viewController.view.addSubview(startingCountDownView)
        NSLayoutConstraint.activate([
            startingCountDownView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            startingCountDownView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            startingCountDownView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            startingCountDownView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
        ])
        startingCountDownView.startingCountDown = startValue
        startingCountDownView.delegate = self
        startingCountDownView.startCountDown()
        self.startingCountDownView = startingCountDownView
    }
    
    fileprivate func falseTapProcessing(of imageView: UIImageView) {
        gameEngine.thisTapWasFalse()
        UIDevice.vibrate()
        imageView.shake()
    }
}

// MARK: - Game Visualization Functions
extension PictureMemoGameInterfaceController {
    fileprivate func indicateCurrentRound() {
        roundsLabel.isHidden = false
        roundsLabel.text = "\(NSLocalizedString("CurrentRound.Label", comment: "Text.Label")) \(gameEngine.getCurrentRound())"
    }
    
    fileprivate func showGuessedItemInWhatCollectionView(_ element: GameElement) {
        self.whatCollectionView?.visibleCells.forEach( {
            (cell: UICollectionViewCell) in
            guard
                let cell = cell as? CollectionViewCell else {
                return
            }
            
            if let cellsElement = cell.gameElement,
                cellsElement.isHidden(),
                cellsElement.getImagesName() == element.getImagesName() {
                cell.configureImageView(with: element.getImage())
            }
        } )
    }
}

// MARK: - OBJC Functions
extension PictureMemoGameInterfaceController {
    @objc
    fileprivate func memorizedButtonTapped(sender: UIButton) {
        self.whatCollectionView?.visibleCells.forEach( {
            (cell: UICollectionViewCell) in
            guard let cell = cell as? CollectionViewCell else {
                return
            }
            
            if let cellsElement = cell.gameElement, cellsElement.isHidden() {
                cell.configureImageView(with: AuxiliaryImageNames.questionMark.getImage())
            }
        } )
        
        whereCollectionView?.isHidden = false
        memorizedButton.isHidden = true
        indicateCurrentRound()
    }
    
    @objc
    fileprivate func startButtonTapped(sender: UIButton) {
        do {
            try startNewGame()
            curtainView.isHidden = true
            countDownLabel.isHidden = false
            
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(seconds), target: self, selector: #selector(roundExpiration), userInfo: nil, repeats: false)
            
            countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownLabelTextUpdate), userInfo: nil, repeats: true)
        } catch AppError.incorrectCountValue {
            viewController.showDialog(title: nil, message: AppError.incorrectCountValue.getErrorText())
        } catch AppError.whereContainerCountIsLessWhanWhatContainerCount {
            viewController.showDialog(title: nil, message: AppError.whereContainerCountIsLessWhanWhatContainerCount.getErrorText())
        } catch {
            viewController.showDialog(title: nil, message: AppError.defaultErrorValue.getErrorText())
        }
    }
    
    @objc
    fileprivate func homeButtonTapped(sender: UIButton) {
        if let homeScreenVC = Bundle.main.loadNibNamed(String(describing: HomeScreenViewController.self), owner: nil, options: nil)?.first as? HomeScreenViewController {
            homeScreenVC.modalTransitionStyle = .crossDissolve
            homeScreenVC.modalPresentationStyle = .fullScreen
            viewController.present(homeScreenVC, animated: true, completion: nil)
        }
    }
    
    @objc
    fileprivate func roundExpiration() {
        curtainView.isHidden = false

        gameTimer = nil
        countDownTimer?.invalidate()
        countDownTimer = nil
        let recordsCalculation = RecordsCalculation(finishedRounds: gameEngine.getFinishedRounds(), gameDuration: gameDuration)
        let totalText = "\(recordsCalculation.getRecordsTitle())\n\(NSLocalizedString("TotalRoundsPlayed.Label", comment: "Text.Label")): \(gameEngine.getFinishedRounds())\n\(NSLocalizedString("TotalFalseTaps.Label", comment: "Text.Label")): \(gameEngine.getNumberOfFalseTaps())"
        totalsLabel.text = totalText
        countDownLabel.isHidden = true
    }
    
    @objc
    fileprivate func countDownLabelTextUpdate() {
        seconds -= 1
        
        let secondsText: String
        if seconds < 10 {
            secondsText = "0\(seconds)"
            countDownLabel.sizeAnimatedTransformation(to: 2, with: 0.5)
        } else {
            secondsText = "\(seconds)"
        }

        self.countDownLabel.text = "00:\(secondsText)"
        
        if seconds == 0 {
            countDownTimer?.invalidate()
        }
    }
    
    @objc
    fileprivate func durationSegmentedControlChanged(sender: UISegmentedControl) {
        settingsController.setNewGameDuration(GameDurations.allCases[sender.selectedSegmentIndex])
        settingsController.saveGameDuration()
        
        refreshGameDuration()
    }
}

// MARK: - Interface Elements Layout Setup
extension PictureMemoGameInterfaceController {
    fileprivate func createWhatCollectionView() {
        let whatContainer = gameEngine.getWhat()
        let flowLayout = GameCollectionViewLayout(numberOfElements: whatContainer.count)
        
        let frame = CGRect(x: 0,
                           y: 0,
                           width: self.whatContainerView.frame.width - 16 - 16,
                           height: self.whatContainerView.frame.height - 16 - 16
                            )
        
        whatCollectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        
        whatCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        whatCollectionViewDataSource = CollectionViewDataSource(container: whatContainer, gameInterfaceController: self)
        whatCollectionView?.dataSource = whatCollectionViewDataSource
        whatCollectionView?.backgroundColor = whatContainerView.backgroundColor
        whatCollectionView?.register(cellType: CollectionViewCell.self, nib: false)
    }
    
    fileprivate func setupWhatContainerViewLayout() {
        guard let whatCollectionView = whatCollectionView else {
            return
        }
        
        whatContainerView.addSubview(whatCollectionView)
        
        NSLayoutConstraint.activate([
            whatCollectionView.topAnchor.constraint(equalTo: whatContainerView.topAnchor, constant: 16),
            whatCollectionView.leadingAnchor.constraint(equalTo: whatContainerView.leadingAnchor, constant: 16),
            whatContainerView.trailingAnchor.constraint(equalTo: whatCollectionView.trailingAnchor, constant: 16),
            whatContainerView.bottomAnchor.constraint(equalTo: whatCollectionView.bottomAnchor, constant: 16),
        ])
    }
    
    fileprivate func createWhereCollectionView() {
        let whereContainer = gameEngine.getWhere()
        let flowLayout = GameCollectionViewLayout(numberOfElements: whereContainer.count)
        
        let frame = CGRect(x: 0,
                           y: 0,
                           width: self.whereContainerView.frame.width - 16 - 16,
                           height: self.whereContainerView.frame.height - 16 - 16
                            )

        whereCollectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)

        whereCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        whereCollectionViewDataSource = CollectionViewDataSource(container: whereContainer, gameInterfaceController: self)
        whereCollectionView?.dataSource = whereCollectionViewDataSource
        whereCollectionView?.backgroundColor = whereContainerView.backgroundColor
        whereCollectionView?.register(cellType: CollectionViewCell.self, nib: false)
    }
    
    fileprivate func setupWhereContainerViewLayout() {
        guard let whereCollectionView = whereCollectionView else {
            return
        }
        
        whereContainerView.addSubview(whereCollectionView)

        NSLayoutConstraint.activate([
            whereCollectionView.topAnchor.constraint(equalTo: whereContainerView.topAnchor, constant: 16),
            whereCollectionView.leadingAnchor.constraint(equalTo: whereContainerView.leadingAnchor, constant: 16),
            whereContainerView.trailingAnchor.constraint(equalTo: whereCollectionView.trailingAnchor, constant: 16),
            whereContainerView.bottomAnchor.constraint(equalTo: whereCollectionView.bottomAnchor, constant: 16),
        ])
        
        whereCollectionView.isHidden = true
    }
    
    fileprivate func setupMemorizedButtonLayout() {
        whereContainerView.addSubview(memorizedButton)
        
        let horizontalMargin: CGFloat = whereContainerView.frame.width / 8
        let verticalMargin: CGFloat = whereContainerView.frame.height / 4
        
        NSLayoutConstraint.activate([
            memorizedButton.centerXAnchor.constraint(equalTo: whereContainerView.centerXAnchor),
            memorizedButton.centerYAnchor.constraint(equalTo: whereContainerView.centerYAnchor),
            memorizedButton.topAnchor.constraint(equalTo: whereContainerView.topAnchor, constant: verticalMargin),
            memorizedButton.leadingAnchor.constraint(equalTo: whereContainerView.leadingAnchor, constant: horizontalMargin),
        ])
    }
    
    fileprivate func setupCurtainViewLayout() {
        curtainView.addSubview(startButton)
        curtainView.addSubview(settingsView)
        
        settingsView.addSubview(settingsTitleLabel)
        settingsView.addSubview(durationSegmentedControl)
        
        let horizontalMargin: CGFloat = curtainView.frame.width / 8
        let verticalSize: CGFloat = curtainView.frame.height / 16
        
        //Start Button layout
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: curtainView.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: curtainView.centerYAnchor),
            startButton.leadingAnchor.constraint(equalTo: curtainView.leadingAnchor, constant: horizontalMargin),
            startButton.heightAnchor.constraint(equalToConstant: verticalSize),
        ])
        
        //Settings View layout
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 16),
            settingsView.centerXAnchor.constraint(equalTo: curtainView.centerXAnchor),
            settingsView.widthAnchor.constraint(equalTo: startButton.widthAnchor),
            
            curtainView.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: 16),
            
            settingsTitleLabel.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 16),
            settingsTitleLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 16),
            settingsTitleLabel.centerXAnchor.constraint(equalTo: settingsView.centerXAnchor),
            
            durationSegmentedControl.centerXAnchor.constraint(equalTo: settingsView.centerXAnchor),
            durationSegmentedControl.centerYAnchor.constraint(equalTo: settingsView.centerYAnchor),
            durationSegmentedControl.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 32),
        ])
    }
    
    fileprivate func setupRoundsLabelLayout() {
        topAuxiliaryView.addSubview(roundsLabel)
        
        NSLayoutConstraint.activate([
            roundsLabel.centerYAnchor.constraint(equalTo: topAuxiliaryView.centerYAnchor),
            roundsLabel.centerXAnchor.constraint(equalTo: topAuxiliaryView.centerXAnchor),
        ])
    }
    
    fileprivate func setupCountDownLabelLayout() {
        bottomAuxiliaryView.addSubview(countDownLabel)
        
        NSLayoutConstraint.activate([
            countDownLabel.centerYAnchor.constraint(equalTo: bottomAuxiliaryView.centerYAnchor),
            countDownLabel.centerXAnchor.constraint(equalTo: bottomAuxiliaryView.centerXAnchor),
        ])
    }
    
    fileprivate func setupTotalsLabelLayout() {
        curtainView.addSubview(totalsLabel)
        
        NSLayoutConstraint.activate([
            totalsLabel.topAnchor.constraint(equalTo: curtainView.topAnchor, constant: 16),
            totalsLabel.leadingAnchor.constraint(equalTo: curtainView.leadingAnchor, constant: 16),
            totalsLabel.centerXAnchor.constraint(equalTo: curtainView.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: totalsLabel.bottomAnchor, constant: 16),
        ])
    }
    
    fileprivate func setupHomeButtonLayout() {
        curtainView.addSubview(homeButton)
        
        NSLayoutConstraint.activate([
            homeButton.topAnchor.constraint(equalTo: curtainView.topAnchor, constant: 16),
            homeButton.leadingAnchor.constraint(equalTo: startButton.leadingAnchor, constant: -8),
            homeButton.widthAnchor.constraint(equalToConstant: 80),
            homeButton.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
}

// MARK: - StartingCountDownView Delegate
extension PictureMemoGameInterfaceController: StartingCountDownViewDelegate {
    internal func startingCountDownViewDismiss() {
        viewController.view.removeSubviews(of: StartingCountDownView.self)
        
        setupNewRound()
        refreshGameDuration()
    }
}
