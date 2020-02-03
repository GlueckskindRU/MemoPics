//
//  PictureItem.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 25.11.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

struct PictureItem {
    private let image: UIImage
    private let imageName: ImagesNames
    
    init() {
        let imageName = ImagesNames.getRandomName()
        self.image = UIImage(imageLiteralResourceName: imageName.rawValue)
        self.imageName = imageName
    }
    
    func getImage() -> UIImage {
        return image
    }
    
    func getName() -> String {
        return imageName.rawValue
    }
    
    func getImagesName() -> ImagesNames {
        return imageName
    }
}

extension PictureItem: Comparable {
    static func < (lhs: PictureItem, rhs: PictureItem) -> Bool {
        return lhs.imageName < rhs.imageName
    }
}

extension PictureItem: Hashable {
    static func ==(lhs: PictureItem, rhs: PictureItem) -> Bool {
        return lhs.imageName == rhs.imageName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageName)
    }
}
