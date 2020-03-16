//
//  AuxiliaryImageNames.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 02.12.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

enum AuxiliaryImageNames: String {
    case questionMark = "Question Mark"
    case settingsIcon = "Settings"
    case homeIcon = "Home"
    case backgroundCard = "Background"
    
    func getImage() -> UIImage {
        return UIImage(imageLiteralResourceName: self.rawValue)
    }
}
