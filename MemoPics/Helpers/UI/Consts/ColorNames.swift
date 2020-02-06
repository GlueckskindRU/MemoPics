//
//  ColorNames.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 05.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

enum ColorNames: String {
    case mainAppColor = "MainAppColor"
    
    func getColor() -> UIColor {
        return UIColor(named: self.rawValue)!
    }
}
