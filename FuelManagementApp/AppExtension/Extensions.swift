//
//  Extensions.swift
//  FuelManagement
//
//  Created by ADJ on 29/07/2024.
//

import UIKit

extension UIFont {
    static func medium(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .medium)
    }
    static func regular(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .regular)
    }
    static func bold(ofSize: CGFloat = 40) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .bold)
    }
}
