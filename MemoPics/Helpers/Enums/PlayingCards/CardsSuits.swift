//
//  CardsSuits.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 11.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

enum CardsSuits: Int, CaseIterable {
    // The majority of suits is set according to the bridge card game (from the strongest to the weakest one):
    // spade > hearts > diamonds > clubs
    case clubs      = 1 // трефы
    case diamonds   = 2 //бубны
    case hearts     = 3 // червы
    case spade      = 4 // пики
    
    static func getRandomSuit() -> CardsSuits {
        //randomElement()
        //A random element from the collection. If the collection is empty, the method returns nil.
        //As we ABSOLUTELY sure that the collection is NOT empty, the force unwrapping has been applied
        return CardsSuits.allCases.randomElement()!
    }
    
    func getTitle() -> String {
        switch self {
        case .clubs:
            return "♣️"
        case .diamonds:
            return "♦️"
        case .hearts:
            return "♥️"
        case .spade:
            return "♠️"
        }
    }
}

extension CardsSuits: Comparable {
    static func < (lhs: CardsSuits, rhs: CardsSuits) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
