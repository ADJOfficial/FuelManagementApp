//
//  CollectionView.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 18/07/2024.
//

import UIKit

class CollectionView: UICollectionView {
    init(backgroundColor: UIColor = .clear){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        super.init(frame: .zero, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
