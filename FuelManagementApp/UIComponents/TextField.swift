//
//  TextField.swift
//  FuelManagementApp
//
//  Created by ADJ on 31/07/2024.
//

import UIKit

class TextField: UITextField {
    init(backgroundColor: UIColor = .systemGray2, cornerRadius: CGFloat = 22, placeholder: String = "", isSecure: Bool = false) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecure
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
