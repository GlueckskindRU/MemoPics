//
//  ImagesNames.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 25.11.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import Foundation

enum ImagesNames: String, CaseIterable {
    case apple = "Apple"
    case cactus = "Cactus"
    case carrot = "Carrot"
    case cherry = "Cherry"
    case citrus = "Citrus"
    case flower = "Flower"
    case grapes = "Grapes"
    case leaf = "Leaf"
    case mappleLeaf = "Mapple Leaf"
    case mushroom = "Mushroom"
    case oakLeaf = "Oak Leaf"
    case pear = "Pear"
    case pineapple = "Pineapple"
    case raspberry = "Raspberry"
    case strawberry = "Strawberry"
    
    static func getRandomName() -> ImagesNames {
        //randomElement()
        //A random element from the collection. If the collection is empty, the method returns nil.
        //As we ABSOLUTELY sure that the collection is NOT empty, the force unwrapping has been applied
        return ImagesNames.allCases.randomElement()!
    }
}

extension ImagesNames: Comparable {
    static func < (lhs: ImagesNames, rhs: ImagesNames) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
