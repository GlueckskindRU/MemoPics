//
//  PlayingCardsViewController.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 18.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class PlayingCardsViewController: UIViewController {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var playingCardTableView: UIView!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var openedCardImageView: UIImageView!
    @IBOutlet weak var closedCardImageView: UIImageView!
    @IBOutlet weak var playingCardsKeyboardView: UIView!
    
    private var gic: PlayingCardsGameInterfaceController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gic = PlayingCardsGameInterfaceController(viewController: self,
                                                  keyboard: playingCardsKeyboardView,
                                                  countingLabel: middleLabel,
                                                  timingLabel: topLabel,
                                                  playingCardsTableView: playingCardTableView,
                                                  openedCardImageView: openedCardImageView,
                                                  closedCardImageView: closedCardImageView
                                                    )
    }
}
