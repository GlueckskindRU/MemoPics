//
//  RecordsScaleTitle.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 29.01.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

enum RecordsScaleTitle: String, CaseIterable {
    case superman
    case professor
    case master
    case bachelor
    case student
    case matriculant
    case novice
    
    func localizedString() -> String {
        // example of using: RecordsScaleTitle.allCases[6].localizedString()
        return NSLocalizedString(self.rawValue, comment: "RecordsScaleTitle")
    }
}
