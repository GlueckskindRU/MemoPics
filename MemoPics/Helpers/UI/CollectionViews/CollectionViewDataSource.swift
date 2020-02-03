//
//  CollectionViewDataSource.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 26.12.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class CollectionViewDataSource: NSObject {
    private let container: [GameElement]
    private let gameInterfaceController: PictureMemoGameInterfaceController
    
    init(container: [GameElement], gameInterfaceController: PictureMemoGameInterfaceController) {
        self.container = container
        self.gameInterfaceController = gameInterfaceController
    }
}

// MARK: - CollectionView Data Source
extension CollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return container.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(of: CollectionViewCell.self, for: indexPath)
        
        cell.configure(with: container[indexPath.row], gic: gameInterfaceController)
        
        return cell
    }
}
