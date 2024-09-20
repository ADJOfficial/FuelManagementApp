//
//  GradientView.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 16/08/2024.
//

import UIKit

class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()
    init(viewCornerRadius: CGFloat = 22, layerCornerRadius: CGFloat = 22, colors: [UIColor]  = [UIColor.systemBlue.withAlphaComponent(0.7),UIColor.white]) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = viewCornerRadius
        gradientLayer.cornerRadius = layerCornerRadius
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
}
