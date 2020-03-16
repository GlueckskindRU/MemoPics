//
//  CardsNominal.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 11.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

enum CardsNominal: Int, CaseIterable {
    case two    = 2
    case three  = 3
    case four   = 4
    case five   = 5
    case six    = 6
    case seven  = 7
    case eigth  = 8
    case nine   = 9
    case ten    = 10
    case jack   = 11 // валет
    case queen  = 12 // дама
    case king   = 13 // король
    case ace    = 14 // туз
    
    static func getRandomNominal() -> CardsNominal {
        //randomElement()
        //A random element from the collection. If the collection is empty, the method returns nil.
        //As we ABSOLUTELY sure that the collection is NOT empty, the force unwrapping has been applied
        return CardsNominal.allCases.randomElement()!
    }
    
    func getTitle() -> String {
        switch self {
        case .ace:
            return NSLocalizedString("CardNominal.Short.Ace", comment: "Text.Label")
        case .king:
            return NSLocalizedString("CardNominal.Short.King", comment: "Text.Label")
        case .queen:
            return NSLocalizedString("CardNominal.Short.Queen", comment: "Text.Label")
        case .jack:
            return NSLocalizedString("CardNominal.Short.Jack", comment: "Text.Label")
        default:
            return "\(rawValue)"
        }
    }
}

extension CardsNominal: Comparable {
    static func < (lhs: CardsNominal, rhs: CardsNominal) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
