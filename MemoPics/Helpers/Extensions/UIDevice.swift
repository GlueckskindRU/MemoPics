//
//  UIDevice.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 10.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit
import AVFoundation

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
