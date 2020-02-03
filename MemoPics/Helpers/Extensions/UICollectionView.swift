//
//  UICollectionView.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 27.12.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<Cell: UICollectionViewCell>(cellType: Cell.Type, nib: Bool = true) {
        let reuseIdentifier = String(describing: cellType)
        
        if nib {
            let nib = UINib(nibName: reuseIdentifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
    
    func dequeueCell<Cell: UICollectionViewCell>(of cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath) as! Cell
    }
}
