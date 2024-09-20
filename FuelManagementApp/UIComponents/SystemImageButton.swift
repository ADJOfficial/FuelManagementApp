//
//  SystemImageButton.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 01/08/2024.
//

import UIKit

class SystemImageButton: UIButton {
    init(image: UIImage?, size: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20), tintColor: UIColor = .systemYellow, setTitle: String = "", setTitleColor: UIColor = .white){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(image, for: .normal)
        self.setPreferredSymbolConfiguration(size, forImageIn: .normal)
        self.tintColor = tintColor
        self.setTitleColor(setTitleColor, for: .normal)
        self.setTitle(setTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
