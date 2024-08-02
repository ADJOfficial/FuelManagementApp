//
//  BackButton.swift
//  FuelManagementApp
//
//  Created by ADJ on 31/07/2024.
//

import UIKit

class BackButton: UIButton {
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage(named: "back"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
