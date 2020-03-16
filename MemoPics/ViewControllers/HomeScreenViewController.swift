//
//  HomeScreenViewController.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 05.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var pictureMemoGameButton: UIButton!
    @IBOutlet weak var cardsMemoGameButton: UIButton!

    @IBAction func pictureMemoGameButtonTapped(_ sender: UIButton) {
        if let pictureMemoGameVC = Bundle.main.loadNibNamed(String(describing: PictureMemoViewController.self), owner: nil, options: nil)?.first as? PictureMemoViewController {
            pictureMemoGameVC.modalTransitionStyle = .crossDissolve
            pictureMemoGameVC.modalPresentationStyle = .fullScreen
            present(pictureMemoGameVC, animated: true, completion: nil)
        }
    }

    @IBAction func cardsMemoGameButtonTapped(_ sender: UIButton) {
        if let playingCardsVC = Bundle.main.loadNibNamed(String(describing: PlayingCardsViewController.self), owner: nil, options: nil)?.first as? PlayingCardsViewController {
            playingCardsVC.modalTransitionStyle = .crossDissolve
            playingCardsVC.modalPresentationStyle = .fullScreen
            present(playingCardsVC, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        homeView.layer.cornerRadius = LayoutConsts.cornerRadius
        pictureMemoGameButton.setTitle(NSLocalizedString("PictureMemGame.Button", comment: "Title.Button"), for: .normal)
        pictureMemoGameButton.layer.cornerRadius = LayoutConsts.cornerRadius
        cardsMemoGameButton.setTitle(NSLocalizedString("CardsMemoGame.Button", comment: "Title.Button"), for: .normal)
        cardsMemoGameButton.layer.cornerRadius = LayoutConsts.cornerRadius
    }
}
