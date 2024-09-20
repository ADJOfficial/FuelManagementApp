//
//  ImageView.swift
//  FuelManagement
//
//  Created by ADJ on 29/07/2024.
//

import UIKit

class BackgroundImageView: UIImageView {
    init(imageName: String = "BackgroundImage") {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = UIImage(named: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
