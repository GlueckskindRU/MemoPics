//
//  PictureMemoViewController.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 25.11.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class PictureMemoViewController: UIViewController {
    @IBOutlet weak var whatView: UIView!
    @IBOutlet weak var whereView: UIView!
    @IBOutlet weak var topAuxiliaryView: UIView!
    @IBOutlet weak var bottomAuxiliaryView: UIView!
    @IBOutlet weak var curtainView: UIView!
    private var gic: PictureMemoGameInterfaceController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whatView.layer.cornerRadius = LayoutConsts.cornerRadius
        whereView.layer.cornerRadius = LayoutConsts.cornerRadius
        
        gic = PictureMemoGameInterfaceController(whatContainerView: whatView,
                                      whereContainerView: whereView,
                                      viewController: self,
                                      topAuxiliaryView: topAuxiliaryView,
                                      bottomAuxiliaryView: bottomAuxiliaryView,
                                      curtainView: curtainView
                                        )
    }
}
