//
//  PlayingCard.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 11.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

struct PlayingCard {
    private let suit: CardsSuits
    private let nominal: CardsNominal
    
    init() {
        self.init(suit: CardsSuits.getRandomSuit(), nominal: CardsNominal.getRandomNominal())
    }
    
    init(suit: CardsSuits, nominal: CardsNominal) {
        self.suit = suit
        self.nominal = nominal
    }
    
    func getImage() -> UIImage {
        let imageName: String
        
        switch suit {
        case .clubs:
            imageName = "\(nominal.rawValue)c"
        case .diamonds:
            imageName = "\(nominal.rawValue)d"
        case .hearts:
            imageName = "\(nominal.rawValue)h"
        case .spade:
            imageName = "\(nominal.rawValue)s"
        }
        
        return UIImage(imageLiteralResourceName: imageName)
    }
    
    func isIncluded(into pack: PackOfCards) -> Bool {
        if nominal > CardsNominal.five {
            return true
        } else {
            return pack == .full
        }
    }
}

extension PlayingCard: Comparable {
    static func < (lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        if lhs.suit == rhs.suit {
            return lhs.nominal < rhs.nominal
        } else {
            return lhs.suit < rhs.suit
        }
    }
}

extension PlayingCard: Hashable {
    static func ==(lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        return (lhs.suit == rhs.suit) && (lhs.nominal == rhs.nominal)
    }
}
