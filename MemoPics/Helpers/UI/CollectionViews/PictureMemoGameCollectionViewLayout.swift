//
//  PictureMemoGameCollectionViewLayout.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 28.12.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class PictureMemoGameCollectionViewLayout: UICollectionViewLayout {
    private let numberOfElements: Int
    private let numberOfColumns: Int = 3
    private let cellPadding: CGFloat = 16
    private var cachedLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    init(numberOfElements: Int) {
        self.numberOfElements = numberOfElements
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var numberOfRows: Int {
        let result = numberOfElements / numberOfColumns
        return result * numberOfColumns < numberOfElements ? result + 1 : result
    }
    
    private var cellSize: CGFloat {
        let defaultSize: CGFloat = 100
        guard let collectionView = collectionView else {
            return defaultSize
        }
        
        let cellWidth: CGFloat = (collectionView.bounds.width / CGFloat(numberOfColumns)) - (2 * cellPadding)
        let cellHeight: CGFloat = (collectionView.bounds.height / CGFloat(numberOfRows)) - (2 * cellPadding)
        let minCellSize = min(cellWidth, cellHeight)
        
        return defaultSize < minCellSize ? defaultSize : minCellSize
    }
    
    private var contentHeight: CGFloat {
        return ((cellSize + (cellPadding * 2)) * CGFloat(numberOfRows))
    }
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.width - ( insets.left + insets.right )
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
    override func prepare() {
        guard
            cachedLayoutAttributes.isEmpty,
            let collectionView = collectionView else {
                return
        }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var column = 0
        var row = 0
        
        let startYOffset = (collectionView.bounds.height - contentHeight) / 2
        var yOffset: [CGFloat] = .init(repeating: startYOffset, count: numberOfColumns)
        let totalItems = collectionView.numberOfItems(inSection: 0)
        
        for item in 0..<totalItems {
            let indexPath = IndexPath(item: item, section: 0)
            
            let height = (cellPadding * 2) + cellSize
            
            let itemsLeft = totalItems - (row * numberOfColumns)
            let columnWidthInCurrentRow: CGFloat
            if itemsLeft < numberOfColumns {
                columnWidthInCurrentRow = contentWidth / CGFloat(itemsLeft)
            } else {
                columnWidthInCurrentRow = columnWidth
            }

            let frame = CGRect(x: CGFloat(column) * columnWidthInCurrentRow,
                               y: yOffset[column],
                               width: columnWidthInCurrentRow,
                               height: height
                                )
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cachedLayoutAttributes.append(attributes)
            
            yOffset[column] = yOffset[column] + height
            
            if (column < (numberOfColumns - 1)) {
                column += 1
            } else {
                column = 0
                row += 1
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // all cells should be allways visibled
        return cachedLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedLayoutAttributes[indexPath.item]
    }
}
