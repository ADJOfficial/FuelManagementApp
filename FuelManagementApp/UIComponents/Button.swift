//
//  Button.swift
//  FuelManagement
//
//  Created by ADJ on 29/07/2024.
//

import UIKit

class Button: UIButton {
    init(backgroundColor: UIColor = .white, cornerRadius: CGFloat = 22, setTitle: String = "", setTitleColor: UIColor = .black) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.setTitle(setTitle, for: .normal)
        self.setTitleColor(setTitleColor, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
