//
//  UICollectionView+Extension.swift
//  wooApp
//
//  Created by Manohar Singh Rawat on 05/04/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import Foundation
extension UICollectionView{
    func calculateCellSize (numberOfColumns columns:Int, of height:CGFloat = 80.0) -> CGSize {
        print("calculateCellSize = \(height)")
        let layout         = self.collectionViewLayout as! UICollectionViewFlowLayout
        let itemSpacing    = layout.minimumInteritemSpacing * CGFloat(columns - 1)
        let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
        let length         = (self.bounds.width - itemSpacing - sectionSpacing) / CGFloat(columns)
        return CGSize(
            width:  length,
            height: length + height
        )
    }
    
    func calculateHalfCellSize (numberOfColumns columns:CGFloat, of height:CGFloat = 80.0) -> CGSize {
        let layout         = self.collectionViewLayout as! UICollectionViewFlowLayout
        let itemSpacing    = layout.minimumInteritemSpacing * CGFloat(columns - 1)
        let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
        let length         = (self.bounds.width - itemSpacing - sectionSpacing) / CGFloat(columns)
        return CGSize(
            width:  length,
            height: length+height
        )
    }
    
    func calculateVerticalCellSize (numberOfColumns columns:Int, of height:CGFloat = 107.0) -> CGSize {
        let layout         = self.collectionViewLayout as! UICollectionViewFlowLayout
        let itemSpacing    = layout.minimumInteritemSpacing * CGFloat(columns - 1)
        let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
        let length         = (self.bounds.width - itemSpacing - sectionSpacing) / CGFloat(columns)
        return CGSize(
            width:  length,
            height: height
        )
    }
}
