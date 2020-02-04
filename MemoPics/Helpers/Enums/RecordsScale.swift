//
//  RecordsScale.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 29.01.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

enum RecordsScale: Double, CaseIterable {
    case superman = 1
    case professor = 1.5
    case master = 1.75
    case bachelor = 2
    case student = 2.5
    case matriculant = 3
    case novice = 4
}

extension RecordsScale: Comparable {
    static func < (lhs: RecordsScale, rhs: RecordsScale) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension RecordsScale: Equatable {
    static func == (lhs: RecordsScale, rhs: RecordsScale) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
