//
//  Label.swift
//  FuelManagement
//
//  Created by ADJ on 29/07/2024.
//

import UIKit

class Label: UILabel {
    init(text: String = "", textColor: UIColor = .white, textFont: UIFont = .bold()) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.textColor = textColor
        self.font = textFont
        self.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
