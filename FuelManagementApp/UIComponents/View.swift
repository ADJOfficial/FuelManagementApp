//
//  View.swift
//  FuelManagementApp
//
//  Created by ADJ on 31/07/2024.
//

import UIKit

class View: UIView {
    init(backgroundColor: UIColor = .systemGray4, cornerRadius: CGFloat = 22) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
