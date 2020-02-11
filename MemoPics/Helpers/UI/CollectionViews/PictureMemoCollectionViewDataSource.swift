//
//  PictureMemoCollectionViewDataSource.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 26.12.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class PictureMemoCollectionViewDataSource: NSObject {
    private let container: [PictureMemoGameElement]
    private let gameInterfaceController: PictureMemoGameInterfaceController
    
    init(container: [PictureMemoGameElement], gameInterfaceController: PictureMemoGameInterfaceController) {
        self.container = container
        self.gameInterfaceController = gameInterfaceController
    }
}

// MARK: - CollectionView Data Source
extension PictureMemoCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return container.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(of: PictureMemoCollectionViewCell.self, for: indexPath)
        
        cell.configure(with: container[indexPath.row], gic: gameInterfaceController)
        
        return cell
    }
}
