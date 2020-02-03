//
//  GameElement.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 04.01.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

struct GameElement {
    private let pictureItem: PictureItem
    private let containerType: ContainerType
    private var shouldBeHidden: Bool
    private var itemIsGuessed: Bool = false
    
    init(pictureItem: PictureItem, containerType: ContainerType, shouldBeHidden: Bool) {
        self.pictureItem = pictureItem
        self.containerType = containerType
        
        switch containerType {
        case .whatToGuess:
            self.shouldBeHidden = shouldBeHidden
        case .whereToGuess:
            self.shouldBeHidden = false
        }
    }
    
    init(containerType: ContainerType, shouldBeHidden: Bool) {
        self.init(pictureItem: PictureItem(), containerType: containerType, shouldBeHidden: shouldBeHidden)
    }
    
    func getItem() -> PictureItem {
        return pictureItem
    }
    
    func getImage() -> UIImage {
        return pictureItem.getImage()
    }
    
    func getName() -> String {
        return pictureItem.getName()
    }
    
    func getImagesName() -> ImagesNames {
        return pictureItem.getImagesName()
    }
    
    func isHidden() -> Bool {
        return shouldBeHidden
    }
    
    func getContainerType() -> ContainerType {
        return containerType
    }
    
    mutating func setAsGuessed() {
        itemIsGuessed = true
    }
    
    func isGuessed() -> Bool {
        return itemIsGuessed
    }
    
    var description: String {
        return "GameElement(pictureItem = <\(pictureItem.getImagesName())>, containerType = <\(containerType)>, shouldBeHidden = <\(shouldBeHidden)>, isGuessed = <\(itemIsGuessed)>)"
    }
}

extension GameElement: Hashable {
    static func ==(lhs: GameElement, rhs: GameElement) -> Bool {
        return lhs.pictureItem == rhs.pictureItem
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(pictureItem)
    }
}
