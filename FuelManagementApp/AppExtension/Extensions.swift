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
    static func bold(ofSize: CGFloat = 25) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .bold)
    }
}
// MARK: AutoSized According to Screen Size
extension Int {
    var autoSized: CGFloat {
        let baseDiagonal: CGFloat = 980.0
        let screenDiagonal = sqrt(pow(UIScreen.main.bounds.width, 2) + pow(UIScreen.main.bounds.height, 2))
        let scale = screenDiagonal / baseDiagonal
        return CGFloat(self) * scale
    }
    var widthRatio: CGFloat {
        let baseWidth: CGFloat = 414.0
        let screenWidth = UIScreen.main.bounds.width
        let scale = screenWidth / baseWidth
        return CGFloat(self) * scale
    }
}
// MARK: For Alerts
extension UIViewController {
    func popupAlert(title: String?, message: String?, style: UIAlertController.Style = .alert, actionTitles: [String?], actionStyles: [UIAlertAction.Style?], actions: [((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }
    func popAlert(title: String, message: String, cancelTitle: String, pushTitle: String, cancel: @escaping () -> Void, push: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel){ _ in
            cancel()
        })
        alert.addAction(UIAlertAction(title: pushTitle, style: .default){ _ in
            push()
        })
        self.present(alert, animated: true)
    }
}
